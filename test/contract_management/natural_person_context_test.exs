defmodule ContractManagement.NaturalPersonContextTest do
  use ContractManagement.DataCase, async: true

  alias ContractManagement.{NaturalPerson, NaturalPersonContext}
  alias Ecto.Changeset

  @natural_person_params %{
    "name" => "name",
    "cpf" => "12345678900",
    "birth_date" => "2000-12-31"
  }

  describe "create/1" do
    test "when params are valid" do
      {:ok, expected_birth_date} = Date.from_iso8601(@natural_person_params["birth_date"])

      assert {:ok,
              %NaturalPerson{
                name: "name",
                cpf: "12345678900",
                birth_date: ^expected_birth_date,
                id: _id
              }} = NaturalPersonContext.create(@natural_person_params)
    end

    test "when already is an user with same cpf" do
      NaturalPersonContext.create(@natural_person_params)

      assert {:error,
              %Changeset{
                errors: [
                  cpf:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "natural_person_cpf_index"]}
                ]
              }} = NaturalPersonContext.create(@natural_person_params)
    end

    test "when there is some invalid param" do
      invalid_params = %{
        "name" => "name",
        "cpf" => "123456789aa",
        "birth_date" => "2000-12-32"
      }

      assert {:error,
              %Changeset{
                errors: _erros
              }} = NaturalPersonContext.create(invalid_params)
    end
  end
end
