defmodule AwesomeApp.UserController do
  use AwesomeApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => id}) do
    user = AwesomeApp.User.full_details_by_id(id)

    render conn, "show.html", user: user
  end
end
