defmodule AwesomeApp.UserController do
  use AwesomeApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => id}) do
    user =
      Repo.one from u in AwesomeApp.User,
        where: u.id == ^id,
        preload: [:phones]

    render conn, "show.html", user: user
  end
end
