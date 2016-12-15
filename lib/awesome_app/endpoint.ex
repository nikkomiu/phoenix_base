defmodule AwesomeApp.Endpoint do
  use Phoenix.Endpoint, otp_app: :awesome_app

  socket "/socket", AwesomeApp.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :awesome_app, gzip: true,
    only: ~w(assets images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug :put_secret_key_base
  defp put_secret_key_base(%{secret_key_base: ""} = conn, _), do:
    put_in conn.secret_key_base, config_or_default(:secret_key_base, System.get_env("SECRET_KEY_BASE"))
  defp put_secret_key_base(conn, _), do: conn

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_awesome_app_key",
    signing_salt: "/kWZJ4XT"

  plug AwesomeApp.Router

  defp config_or_default(key, default) do
    case Application.fetch_env(:awesome_app, key) do
      :error ->
        default
      {:ok, data} ->
        data
    end
  end
end
