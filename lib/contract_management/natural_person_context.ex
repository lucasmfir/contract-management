defmodule ContractManagement.NaturalPersonContext do
  alias ContractManagement.{NaturalPerson, Repo}

  import Ecto.Query

  def get_all() do
    query = from(n_p in NaturalPerson)

    natural_people = Repo.all(query)

    {:ok, natural_people}
  end

  def create(params) do
    params
    |> NaturalPerson.changeset()
    |> Repo.insert()
  end
end
