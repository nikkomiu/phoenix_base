use Mix.Config

config :awesome_app, AwesomeApp.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "http", host: "localhost", port: 8080],
#  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: {:system, "SECRET_KEY_BASE"},
  cache_static_manifest: "priv/static/manifest.json"

config :awesome_app, AwesomeApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "15")

# Do not print debug messages in production
config :logger, level: :info

config :guardian, Guardian,
  secret_key: {:system, "SECRET_KEY_BASE"}

config :phoenix, :serve_endpoints, true

# import_config "prod.secret.exs"
