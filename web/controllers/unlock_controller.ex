defmodule PhoenixBase.UnlockController do
  use PhoenixBase.Web, :controller

  alias PhoenixBase.Auth

  def forgot_password(conn, _params) do
    conn
    |> render("forgot_password.html")
  end

  def forgot_password_submit(conn, %{"session" => %{"email" => email}}) do
    case Auth.forgot_password(conn, email) do
      _ ->
        conn
        |> put_flash(:info,
          "If an account with that email exists " <>
          "reset instructions have been sent to you.")
        |> redirect(to: session_path(conn, :new))
      {:error, :update_token} ->
        conn
        |> put_flash(:info, "Password reset instructions have been sent to you.")
        |> render("forgot_password.html")
    end
  end

  def password_reset(conn, %{"token" => token}) do
    {uuid_status, token_uuid} = Ecto.UUID.cast(token)

    cond do
      uuid_status == :error ->
        conn
        |> put_flash(:error, "Reset token is not in correct format.")
        |> redirect(to: session_path(conn, :new))

      user_login = PhoenixBase.UserStore.find_user_login_by_reset_token(token_uuid) ->
        conn
        |> render("reset_password.html", user_login: user_login)

      true ->
        conn
        |> put_flash(:error, "The token was either not found or has expired. "<>
          "Please request a new reset token.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def password_reset(conn, _params) do
    conn
    |> put_flash(:error, "Please be sure to follow the link in your email.")
    |> redirect(to: session_path(conn, :new))
  end

  def complete_password_reset(conn, %{"reset" => reset_params}) do
    # TODO reset the password
    conn
  end
end
