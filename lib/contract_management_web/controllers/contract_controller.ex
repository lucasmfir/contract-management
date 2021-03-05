defmodule ContractManagementWeb.ContractController do
  use ContractManagementWeb, :controller

  action_fallback ContractManagementWeb.FallbackController

  def create(conn, params) do
    with {:ok, contract} <- ContractManagement.create_contract(params) do
      conn
      |> put_status(:created)
      |> render("create.json", contract: contract)
    end
  end
end
