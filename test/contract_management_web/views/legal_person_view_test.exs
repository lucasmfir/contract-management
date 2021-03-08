defmodule ContractManagementWeb.NaturalPersonViewTest do
  use ContractManagementWeb.ConnCase, async: true

  import Phoenix.View

  alias ContractManagement.NaturalPerson
  alias ContractManagementWeb.NaturalPersonView

  test "renders create.json" do
    params = %{
      "name" => "nome",
      "cpf" => "12345678900",
      "birth_date" => "2000-10-10"
    }

    {:ok, %NaturalPerson{} = person} = ContractManagement.create_natural_person(params)

    response = render(NaturalPersonView, "create.json", natural_person: person)

    expected_response = %{
      message: "natural person created",
      natural_person: %{
        id: person.id,
        name: person.name,
        cpf: person.cpf
      }
    }

    assert expected_response == response
  end
end
