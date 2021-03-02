defmodule ContractManagementWeb.LegalPersonController do
  use ContractManagementWeb, :controller

  action_fallback ContractManagementWeb.FallbackController

  def create(conn, params) do
    with {:ok, legal_person} <- ContractManagement.create_legal_person(params) do
      conn
      |> put_status(:created)
      |> render("create.json", legal_person: legal_person)
    end
  end
end
