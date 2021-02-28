defmodule ContractManagementWeb.NaturalPersonController do
  use ContractManagementWeb, :controller

  action_fallback ContractManagementWeb.FallbackController

  def create(conn, params) do
    with {:ok, natural_person} <- ContractManagement.create_natural_person(params) do
      conn
      |> put_status(:created)
      |> render("create.json", natural_person: natural_person)
    end
  end
end
