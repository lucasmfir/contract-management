defmodule ContractManagement.NaturalPersonContext do
  alias ContractManagement.{NaturalPerson, Repo}

  def create(params) do
    params
    |> NaturalPerson.changeset()
    |> Repo.insert()
  end
end