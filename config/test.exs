use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_base, PhoenixBase.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_base, PhoenixBase.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "ecto://postgres:postgres@postgres/phoenix_base_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :phoenix_base, PhoenixBase.Mailer,
  adapter: Bamboo.TestAdapter
