defmodule ContractManagementWeb.NaturalPersonView do
  def render("create.json", %{natural_person: natural_person}) do
    %{
      message: "natural person created",
      natural_person: natural_person_view(natural_person)
    }
  end

  def render("index.json", %{natural_people: natural_people}) do
    %{
      natural_people: natural_people_view(natural_people)
    }
  end

  defp natural_person_view(natural_person) do
    %{
      id: natural_person.id,
      name: natural_person.name,
      cpf: natural_person.cpf
    }
  end

  defp natural_people_view(natural_people) do
    Enum.map(natural_people, fn natural_person ->
      natural_person_view(natural_person)
    end)
  end
end
