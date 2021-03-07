defmodule ContractManagementWeb.LegallPersonControllerTest do
  use ContractManagementWeb.ConnCase, async: true

  alias ContractManagement.LegalPersonContext

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

  describe "create/2" do
    test "when valid params create legal person", %{conn: conn} do
      response =
        conn
        |> post(Routes.legal_person_path(conn, :create, @legal_person_params))
        |> json_response(:created)

      assert %{
               "message" => "legal person created",
               "legal_person" => %{
                 "id" => _id,
                 "name" => "name"
               }
             } = response
    end

    test "when invalid params returns error", %{conn: conn} do
      invalid_params = Map.merge(@legal_person_params, %{"cnpj" => "abc"})

      response =
        conn
        |> post(Routes.legal_person_path(conn, :create, invalid_params))
        |> json_response(:bad_request)

      assert %{"message" => %{} = _errors} = response
    end
  end

  describe "index/2" do
    test "when there is legal people to list", %{conn: conn} do
      LegalPersonContext.create(@legal_person_params)

        @legal_person_params
        |> Map.put("cnpj", "99999999999900")
        |> LegalPersonContext.create()

      response =
        conn
        |> get(Routes.legal_person_path(conn, :index))
        |> json_response(:ok)

      assert %{"legal_people" => [_ | _]} = response
      assert length(response["legal_people"]) == 2
    end

    test "when there is no legal people", %{conn: conn} do
      response =
        conn
        |> get(Routes.legal_person_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "legal_people" => []
             } = response
    end
  end
end
