defmodule ContractManagementWeb.ContractController do
  use ContractManagementWeb, :controller

  action_fallback ContractManagementWeb.FallbackController

  def index(conn, _params) do
    with {:ok, contracts} <- ContractManagement.get_contracts() do
      conn
      |> put_status(:ok)
      |> render("index.json", contracts: contracts)
    end
  end

  def create(conn, params) do
    with {:ok, contract} <- ContractManagement.create_contract(params) do
      conn
      |> put_status(:created)
      |> render("create.json", contract: contract)
    end
  end
end
