defmodule PhoenixBase.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix_base

  socket "/socket", PhoenixBase.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :phoenix_base, gzip: true,
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

#  plug :put_secret_key_base
#  defp put_secret_key_base(%{secret_key_base: key} = conn, _) do
#    case key do
#      {:system, sys_var} ->
#        put_in conn.secret_key_base, System.get_env(sys_var)
#      _ ->
#        conn
#    end
#  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_phoenix_base_key",
    signing_salt: "/kWZJ4XT"

  plug PhoenixBase.Router
end
