defmodule ContractManagement.Repo do
  use Ecto.Repo,
    otp_app: :contract_management,
    adapter: Ecto.Adapters.Postgres
end
