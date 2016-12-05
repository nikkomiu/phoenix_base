defmodule AwesomeApp.PageController do
  use AwesomeApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
