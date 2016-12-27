use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :phoenix_base, PhoenixBase.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [npm: ["run", "watch"]]

# Watch static and templates for browser reloading.
config :phoenix_base, PhoenixBase.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex|slim|slime)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configures the email service
config :phoenix_base, PhoenixBase.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-1686c5af83978895069b50b025f2fb2b",
  domain: "sandbox979dea49d3524660b545b6de0cd7812e.mailgun.org"

# Configure your database
config :phoenix_base, PhoenixBase.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "ecto://postgres:postgres@postgres/phoenix_base_dev"
  pool_size: 10
