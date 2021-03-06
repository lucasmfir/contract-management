defmodule ContractManagementWeb.LegalPersonView do
  def render("create.json", %{legal_person: legal_person}) do
    %{
      message: "legal person created",
      legal_person: legal_person_view(legal_person),
      address: address_view(legal_person.address)
    }
  end

  defp legal_person_view(legal_person) do
    %{
      id: legal_person.id,
      name: legal_person.name,
      cnpj: legal_person.cnpj
    }
  end

  defp address_view(address) do
    %{
      country: address.country,
      state: address.state,
      city: address.city,
      street: address.street,
      zip_code: address.zip_code
    }
  end
end
