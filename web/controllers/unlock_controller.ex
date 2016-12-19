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
    case Auth.user_login_from_reset_token(token) do
      {:ok, user_login} ->
        changeset = PhoenixBase.UserLogin.registration_changeset(user_login)

        conn
        |> render("reset_password.html", changeset: changeset, token: token)

      {:error, _} ->
        conn
        |> put_flash(:error, "The token was either not found or has expired. "<>
          "Please request a new password reset token.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def password_reset(conn, _params) do
    conn
    |> put_flash(:error, "Please be sure to follow the link in your email.")
    |> redirect(to: session_path(conn, :new))
  end

  def complete_password_reset(conn, %{"user_login" => %{"token" => token} = reset_params}) do
    case Auth.user_login_from_reset_token(token) do
      {:ok, user_login} ->
        changeset = PhoenixBase.UserLogin.registration_changeset(user_login, reset_params)

        case PhoenixBase.Repo.update(changeset) do
          {:ok, _} ->
            conn
            |> put_flash(:info, "Your password has been successfully updated.")
            |> redirect(to: session_path(conn, :new))
          {:error, changeset} ->
            conn
            |> render("reset_password.html", changeset: changeset, token: token)
        end
      {:error, _} ->
        conn
        |> put_flash(:error, "The token was either not found or has expired. "<>
          "Please request a new password reset token.")
        |> redirect(to: session_path(conn, :new))
    end
  end
end
