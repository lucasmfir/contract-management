defmodule ContractManagementWeb.NaturalPersonView do
  def render("create.json", %{natural_person: natural_person}) do
    %{
      message: "natural person created",
      natural_person: %{
        id: natural_person.id,
        name: natural_person.name
      }
    }
  end
end
