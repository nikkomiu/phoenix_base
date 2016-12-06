defmodule AwesomeApp.SessionController do
  use AwesomeApp.Web, :controller

  def new(conn, _params) do
    changeset = AwesomeApp.User.session_changeset(%AwesomeApp.User{})

    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case AwesomeApp.User.find_and_confirm_password(email, password) do
      {true, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {false, _} ->
        conn
        |> put_flash(:error, "Incorrect Email or Password.")
        |> render "new.html", email: email
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