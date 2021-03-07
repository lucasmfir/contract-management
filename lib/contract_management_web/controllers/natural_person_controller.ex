defmodule ContractManagementWeb.NaturalPersonController do
  use ContractManagementWeb, :controller

  action_fallback ContractManagementWeb.FallbackController

  def index(conn, _params) do
    with {:ok, natural_people} <- ContractManagement.list_natural_people() do
      conn
      |> put_status(:ok)
      |> render("index.json", natural_people: natural_people)
    end
  end

  def create(conn, params) do
    with {:ok, natural_person} <- ContractManagement.create_natural_person(params) do
      conn
      |> put_status(:created)
      |> render("create.json", natural_person: natural_person)
    end
  end
end
