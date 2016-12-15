# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :awesome_app,
  ecto_repos: [AwesomeApp.Repo]

# Configures the endpoint
config :awesome_app, AwesomeApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YcfOzbUtlmWv9Bio0HSOsr644Cw2KXOG3bOZEa/xRH1Vx6AXB0s6SAMdMcqHTSID",
  render_errors: [view: AwesomeApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AwesomeApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures the email service
config :awesome_app, AwesomeApp.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.mailgun.org",
  port: 465,
  username: "testing@sandbox979dea49d3524660b545b6de0cd7812e.mailgun.org",
  password: "password1",
  tls: :if_available, # also :always or :never
  ssl: true,
  retries: 3

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "AwesomeApp",
  ttl: { 30, :days },
  secret_key: "UxzJ7n4P9/WGAGMIHcrQruQ8mABkf89Thg+2MdGBUCeeJ/YxRMuXRy0WrNp1aPgt",
  serializer: AwesomeApp.GuardianSerializer

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :distillery,
  no_warn_missing: [
    :elixir_make,
    :distillery
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
