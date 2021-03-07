defmodule ContractManagement.ContractContext do
  alias ContractManagement.{Contract, ContractPerson, Repo}

  alias Ecto.Multi

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
end
