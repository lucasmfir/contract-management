defmodule ContractManagementWeb.FallbackController do
  use ContractManagementWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ContractManagementWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
