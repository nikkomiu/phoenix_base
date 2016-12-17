defmodule PhoenixBase.UserController do
  use PhoenixBase.Web, :controller

  alias PhoenixBase.UserStore

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"username" => username}) do
    user = UserStore.find_by_username(username)

    render conn, "show.html", user: user
  end
end
