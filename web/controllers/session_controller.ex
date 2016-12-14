defmodule AwesomeApp.SessionController do
  use AwesomeApp.Web, :controller

  def new(conn, _params) do
    # TODO: Don't show form if logged in
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    # TODO: Don't log in if logged in
    case AwesomeApp.Auth.login_by_username_and_password(conn, session_params) do
      {:ok, conn} ->
        conn
        |> redirect(to: "/")
      {:error, :locked, conn} ->
        conn
        |> put_flash(:error, "Your account is locked. Check your email for unlock instructions or contact your administrator.")
        |> render("new.html", username: session_params.username)
      {:error, :unconfirmed, conn} ->
        conn
        |> put_flash(:error, "Your account is unconfirmed. Check your email for confirmation instructions.")
        |> render("new.html", username: session_params.username)
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Incorrect Email or Password.")
        |> render("new.html", username: session_params.username)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: "/")
  end

  def forgot(%{method: "GET"} = conn, _params) do
    conn
    |> render("forgot.html")
  end

  def forgot(%{method: "POST"} = conn, %{"session" => %{"email" => email}}) do
    AwesomeApp.Auth.forgot_password(email)

    conn
    |> put_flash(:info, "Password reset instructions have been sent to you.")
    |> render("forgot.html")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to sign in to do that.")
    |> redirect(to: session_path(conn, :new))
  end

  def already_authenticated(conn, _params) do
    conn
    |> put_flash(:info, "You are already logged in.")
    |> redirect(to: "/")
  end
end
