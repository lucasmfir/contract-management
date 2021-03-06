defmodule ContractManagementWeb.ContractView do
  def render("create.json", %{contract: contract}) do
    %{
      message: "contract created",
      contract: %{
        id: contract.id,
        name: contract.name,
        natural_people: contract.natural_people,
        legal_people: contract.legal_people
      }
    }
  end
end
