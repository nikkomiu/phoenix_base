defmodule AwesomeApp.PageController do
  use AwesomeApp.Web, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:error, "Something really cool.")
    |> render("index.html")
  end

  def about(conn, _params) do
    conn
    |> render("about.html")
  end
end
