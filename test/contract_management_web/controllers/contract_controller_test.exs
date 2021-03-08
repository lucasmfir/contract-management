defmodule ContractManagementWeb.ContractControllerTest do
  use ContractManagementWeb.ConnCase, async: true

  alias ContractManagement.{
    ContractContext,
    LegalPersonContext,
    NaturalPersonContext
  }

  @natural_person_params %{
    "name" => "name",
    "cpf" => "12345678900",
    "birth_date" => "2000-12-31"
  }

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

  @contract_params %{
    "name" => "contrato 22",
    "description" => "descricao do contrato",
    "date" => "2021-01-12"
  }

  describe "index/2" do
    setup %{conn: conn} do
      {:ok, natural_person} = NaturalPersonContext.create(@natural_person_params)
      {:ok, legal_person} = LegalPersonContext.create(@legal_person_params)

      {:ok, conn: conn, natural_person: natural_person, legal_person: legal_person}
    end

    test "when is called without filters", %{
      conn: conn,
      natural_person: natural_person,
      legal_person: legal_person
    } do
      upload_file = %Plug.Upload{
        path: "test/files/file.pdf",
        filename: "file name",
        content_type: "application/pdf"
      }

      contract_params =
        Map.merge(
          @contract_params,
          %{
            "file_data" => upload_file,
            "legal_people" => legal_person.id,
            "natural_people" => natural_person.id
          }
        )

      {:ok, contract} = ContractContext.create(contract_params)

      response =
        conn
        |> get(Routes.contract_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "contracts" => [
                 %{
                   "description" => "descricao do contrato",
                   "id" => contract.id,
                   "legal_people" => [legal_person.id],
                   "name" => "contrato 22",
                   "natural_people" => [natural_person.id]
                 }
               ]
             } == response
    end
  end
end
