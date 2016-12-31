use Mix.Config

config :phoenix_base, PhoenixBase.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "http", host: "localhost", port: 8080],
#  force_ssl: [rewrite_on: [:x_forwarded_proto]],
#  secret_key_base: {:system, "SECRET_KEY_BASE"},
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "${SECRET_KEY_BASE}",
  cache_static_manifest: "priv/static/manifest.json"

config :phoenix_base, PhoenixBase.Repo,
  adapter: Ecto.Adapters.Postgres,
#  url: {:system, "DATABASE_URL"},
  url: System.get_env("DATABASE_URL") || "${DATABASE_URL}",
  pool_size: 15

# Do not print debug messages in production
config :logger, level: :info

config :guardian, Guardian,
  secret_key: System.get_env("SECRET_KEY_BASE") || "${SECRET_KEY_BASE}"

config :phoenix, :serve_endpoints, true

# import_config "prod.secret.exs"
