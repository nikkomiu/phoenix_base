defmodule AwesomeApp.PageController do
  use AwesomeApp.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, [handler: AwesomeApp.SessionController] when action in [:about]

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def about(conn, _params) do
    conn
    |> render("about.html")
  end
end
