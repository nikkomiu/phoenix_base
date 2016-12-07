defmodule AwesomeApp.PageController do
  use AwesomeApp.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def about(conn, _params) do
    conn
    |> render("about.html")
  end
end
