defmodule ContractManagementWeb.ContractView do
  def render("create.json", %{contract: contract}) do
    %{
      message: "contract created"
      # natural_person: %{
      #   id: natural_person.id,
      #   name: natural_person.name
      # }
    }
  end
end
