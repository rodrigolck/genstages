# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :genstages, GenstagesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8vz1bpcSd4nkxTFMq8gZvnKzWLbQ0/gSpEGAM8OdLSwia6GsiquUFYWGQMkz1y8e",
  render_errors: [view: GenstagesWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Genstages.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :amqp,
  url: "amqp://guest:guest@localhost"

# Possible scenarios: ["P-C", "P-PC-C", "P-CS", "RMQP-CS", "B-C"]
config :genstages, :scenario, "P-C"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
