defmodule ContractManagementWeb.NaturalPersonControllerTest do
  use ContractManagementWeb.ConnCase, async: true

  alias ContractManagement.NaturalPersonContext

  @natural_person_params %{
    "name" => "name",
    "cpf" => "12345678900",
    "birth_date" => "2000-12-31"
  }

  describe "create/2" do
    test "when valid params create natural person", %{conn: conn} do
      response =
        conn
        |> post(Routes.natural_person_path(conn, :create, @natural_person_params))
        |> json_response(:created)

      assert %{
               "message" => "natural person created",
               "natural_person" => %{
                 "id" => _id,
                 "name" => "name"
               }
             } = response
    end

    test "when invalid params returns error", %{conn: conn} do
      invalid_params = Map.merge(@natural_person_params, %{"cpf" => "abc"})

      response =
        conn
        |> post(Routes.natural_person_path(conn, :create, invalid_params))
        |> json_response(:bad_request)

      assert %{"message" => %{} = _errors} = response
    end
  end

  describe "index/2" do
    test "when there is natural people to list", %{conn: conn} do
      NaturalPersonContext.create(@natural_person_params)

      @natural_person_params
      |> Map.put("cpf", "99999999900")
      |> NaturalPersonContext.create()

      response =
        conn
        |> get(Routes.natural_person_path(conn, :index))
        |> json_response(:ok)

      assert %{"natural_people" => [_ | _]} = response
      assert length(response["natural_people"]) == 2
    end

    test "when there is no natural people", %{conn: conn} do
      response =
        conn
        |> get(Routes.natural_person_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "natural_people" => []
             } = response
    end
  end
end
