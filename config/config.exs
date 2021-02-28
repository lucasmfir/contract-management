# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :contract_management,
  ecto_repos: [ContractManagement.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :contract_management, ContractManagementWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ClhVJpYuKV/LO9VqKU01qkbYCx03K1GMBhzPVvClLY0E9xDg1dYz03ARsPEZAW8+",
  render_errors: [view: ContractManagementWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ContractManagement.PubSub,
  live_view: [signing_salt: "JXr0IKds"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
