defmodule ContractManagementWeb.ContractView do
  def render("index.json", %{contracts: contracts}) do
    %{
      contracts: contracts_view(contracts)
    }
  end

  def render("create.json", %{contract: contract}) do
    %{
      message: "contract created",
      contract: contract_view(contract)
    }
  end

  defp contract_view(contract) do
    %{
      id: contract.id,
      name: contract.name,
      description: contract.description,
      natural_people: contract.natural_people,
      legal_people: contract.legal_people
    }
  end

  defp contracts_view(contracts) do
    Enum.map(contracts, fn contract ->
      contract_view(contract)
    end)
  end
end
