defmodule AwesomeApp.SessionController do
  use AwesomeApp.Web, :controller

  def new(conn, _params) do
    # TODO: Don't show form if logged in
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    # TODO: Don't log in if logged in
    case AwesomeApp.Auth.login_by_username_and_password(conn, username, password) do
      {:ok, conn} ->
        conn
        |> redirect(to: "/")
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Incorrect Email or Password.")
        |> render("new.html", username: username)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: "/")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to sign in to do that.")
    |> redirect(to: session_path(conn, :new))
  end
end
