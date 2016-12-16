defmodule PhoenixBase.UserController do
  use PhoenixBase.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"username" => username}) do
    user = PhoenixBase.UserStore.find_by_username(username)

    render conn, "show.html", user: user
  end
end
