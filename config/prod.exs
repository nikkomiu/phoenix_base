use Mix.Config

config :phoenix_base, PhoenixBase.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "http", host: "localhost", port: 8080],
#  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: {:system, "SECRET_KEY_BASE"},
  cache_static_manifest: "priv/static/manifest.json"

config :phoenix_base, PhoenixBase.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "15")

# Do not print debug messages in production
config :logger, level: :info

config :guardian, Guardian,
  secret_key: "${SECRET_KEY_BASE}"

config :phoenix, :serve_endpoints, true

# import_config "prod.secret.exs"
