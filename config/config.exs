# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_base,
  ecto_repos: [PhoenixBase.Repo]

# Configures the endpoint
config :phoenix_base, PhoenixBase.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YcfOzbUtlmWv9Bio0HSOsr644Cw2KXOG3bOZEa/xRH1Vx6AXB0s6SAMdMcqHTSID",
  render_errors: [view: PhoenixBase.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixBase.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures the email service
config :phoenix_base, PhoenixBase.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-1686c5af83978895069b50b025f2fb2b",
  domain: "sandbox979dea49d3524660b545b6de0cd7812e.mailgun.org"
#  adapter: Bamboo.SMTPAdapter,
#  server: "smtp.mailgun.org",
#  port: 465,
#  username: "testing@sandbox979dea49d3524660b545b6de0cd7812e.mailgun.org",
#  password: "password1",
#  tls: :if_available, # also :always or :never
#  ssl: true,
#  retries: 3

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "PhoenixBase",
  ttl: { 30, :days },
  secret_key: "UxzJ7n4P9/WGAGMIHcrQruQ8mABkf89Thg+2MdGBUCeeJ/YxRMuXRy0WrNp1aPgt",
  serializer: PhoenixBase.GuardianSerializer

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
