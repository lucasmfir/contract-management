defmodule ContractManagement.LegalPersonContext do
  alias ContractManagement.{Address, LegalPerson, Repo}

  import Ecto.Query

  alias Ecto.Multi

  def get_all do
    query = from l_p in LegalPerson, preload: [:address]

    legal_people = Repo.all(query)

    {:ok, legal_people}
  end

  def create(params) do
    Multi.new()
    |> Multi.insert(:create_legal_person, LegalPerson.changeset(params))
    |> Multi.run(:create_address, fn repo, %{create_legal_person: legal_person} ->
      insert_address(params["address"], legal_person.id, repo)
    end)
    |> run_transaction
  end

  defp insert_address(address_data, legal_person_id, repo) do
    address_data
    |> Map.put("legal_person_id", legal_person_id)
    |> Address.changeset()
    |> repo.insert()
  end

  defp run_transaction(transaction) do
    case Repo.transaction(transaction) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      {:ok, %{create_legal_person: legal_person}} ->
        {:ok, Repo.preload(legal_person, :address)}
    end
  end
end
