defmodule ContractManagement.ContractContext do
  alias ContractManagement.{Contract, Repo}

  def create(params) do

    {:ok, file_data} = 
      File.read(params["file"].path)

    params
    |> Map.merge(%{"file" => file_data})
    |> Contract.changeset()
    |> Repo.insert()
  end
end
