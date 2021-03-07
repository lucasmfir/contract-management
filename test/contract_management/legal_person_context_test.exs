defmodule ContractManagement.LegalPersonContextTest do
  use ContractManagement.DataCase, async: true

  alias ContractManagement.{Address, LegalPerson, LegalPersonContext}
  alias Ecto.Changeset

  @address_params %{
    "country" => "BR",
    "state" => "MG",
    "city" => "BH",
    "street" => "rua horizonte",
    "zip_code" => "31123456"
  }

  @legal_person_params %{
    "name" => "name",
    "cnpj" => "11122233344455",
    "address" => @address_params
  }

  describe "create/1" do
    test "when params are valid" do
      assert {:ok,
              %LegalPerson{
                name: "name",
                cnpj: "11122233344455",
                id: _id,
                address: %Address{
                  country: "BR",
                  state: "MG",
                  city: "BH",
                  street: "rua horizonte",
                  zip_code: "31123456"
                }
              }} = LegalPersonContext.create(@legal_person_params)
    end

    test "when already is a legal person with same cnpj" do
      LegalPersonContext.create(@legal_person_params)

      assert {:error,
              %Changeset{
                errors: [
                  cnpj:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "legal_person_cnpj_index"]}
                ]
              }} = LegalPersonContext.create(@legal_person_params)
    end

    test "when there is some invalid param" do
      invalid_params = Map.put(@legal_person_params, "cnpj", "123123")

      assert {:error,
              %Changeset{
                errors: _erros
              }} = LegalPersonContext.create(invalid_params)
    end
  end
end
