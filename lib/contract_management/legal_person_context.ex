defmodule ContractManagement.LegalPersonContext do
  alias ContractManagement.{Address, LegalPerson, Repo}
  alias Ecto.Multi

  def create(%{"legal_person" => legal_person_data, "address" => address_data}) do
    Multi.new()
    |> Multi.insert(:create_legal_person, LegalPerson.changeset(legal_person_data))
    |> Multi.run(:create_address, fn repo, %{create_legal_person: legal_person} ->
      insert_address(address_data, legal_person.id, repo)
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
