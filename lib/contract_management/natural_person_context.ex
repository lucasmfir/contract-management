defmodule ContractManagement.NaturalPersonContext do
  alias ContractManagement.{NaturalPerson, Repo}

  def create(params) do
    case insert_natural_person(params) do
      {:error, reason} ->
        {:error, reason}

      {:ok, natural_person} ->
        {:ok, Map.from_struct(natural_person)}
    end
  end

  defp insert_natural_person(params) do
    params
    |> NaturalPerson.changeset()
    |> Repo.insert()
  end
end
