defmodule ContractManagement.ContractContext do
  alias ContractManagement.{Contract, ContractPerson, Repo}

  alias Ecto.Multi

  import Ecto.Query

  def get_contracts(params) do
    query =
      from(c in Contract)
      |> apply_query_filter(:people_ids, params)
      |> apply_query_filter(:date, params)

    contracts_response =
      from(_ in query, preload: [:contract_person])
      |> Repo.all()
      |> format_contracts_response()

    {:ok, contracts_response}
  end

  defp apply_query_filter(query, :people_ids, %{"peopleIds" => people_ids}) do
    people_ids_list = String.split(people_ids, ",")

    from c in query,
      join: c_p in ContractPerson,
      on: c_p.contract_id == c.id,
      where: c_p.person_id in ^people_ids_list
  end

  defp apply_query_filter(query, :date, %{"dates" => dates}) do
    dates =
      dates
      |> String.split(",")
      |> Enum.map(fn date -> Date.from_iso8601(date) end)

    case dates do
      [{:ok, date1}, {:ok, date2}] ->
        from c in query,
          where: c.date >= ^date1 and c.date <= ^date2

      [{:ok, date}] ->
        from c in query,
          where: c.date == ^date

      _ ->
        query
    end
  end

  defp apply_query_filter(query, _filter_type, _params), do: query

  def create(params) do
    Multi.new()
    |> Multi.insert(:create_contract, Contract.changeset(params))
    |> Multi.run(:create_contract_legal_person, fn _repo, %{create_contract: contract} ->
      params["legal_people"]
      |> contract_people_list(contract.id, :legal_person)
      |> insert_contract_people()
    end)
    |> Multi.run(:create_contract_natural_person, fn _repo, %{create_contract: contract} ->
      params["natural_people"]
      |> contract_people_list(contract.id, :natural_person)
      |> insert_contract_people()
    end)
    |> run_transaction
  end

  defp contract_people_list(nil, _contract_id, _person_type), do: []

  defp contract_people_list(people_ids, contract_id, person_type) do
    people_ids
    |> String.split(",")
    |> Enum.map(fn person_id ->
      %{
        contract_id: contract_id,
        person_id: person_id,
        person_type: person_type
      }
    end)
  end

  defp run_transaction(transaction) do
    case Repo.transaction(transaction) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      {:ok, contract_data} ->
        response =
          contract_data.create_contract
          |> Map.merge(%{
            legal_people: contract_data.create_contract_legal_person,
            natural_people: contract_data.create_contract_natural_person
          })

        {:ok, response}
    end
  end

  defp insert_contract_people(contract_people_list) do
    {_num_inserted, contract_people} =
      Repo.insert_all(ContractPerson, contract_people_list, returning: [:person_id])

    people_ids = Enum.map(contract_people, fn contract_person -> contract_person.person_id end)

    {:ok, people_ids}
  end

  defp extract_people_from_contract(contract, person_type) do
    Enum.filter(contract.contract_person, fn contract_person ->
      contract_person.person_type == person_type
    end)
  end

  defp extract_people_ids(people) do
    Enum.map(people, fn person ->
      person.person_id
    end)
  end

  defp people_ids_list(contract, person_type) do
    contract
    |> extract_people_from_contract(person_type)
    |> extract_people_ids()
  end

  defp format_contracts_response(contracts) do
    Enum.map(contracts, fn contract ->
      legal_people_ids = people_ids_list(contract, :legal_person)

      natural_people_ids = people_ids_list(contract, :natural_person)

      contract
      |> Map.put(:legal_people, legal_people_ids)
      |> Map.put(:natural_people, natural_people_ids)
    end)
  end
end
