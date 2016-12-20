defmodule PhoenixBase.UnlockController do
  use PhoenixBase.Web, :controller

  alias PhoenixBase.Auth

  def forgot_password(conn, _params) do
    conn
    |> render("forgot_password.html")
  end

  def forgot_password_submit(conn, %{"session" => %{"email" => email}}) do
    case Auth.forgot_password(conn, email) do
      {:error, :update_token} ->
        conn
        |> put_flash(:info, "Could not send email. Please try again later.")
        |> render("forgot_password.html")
      _ ->
        conn
        |> put_flash(:info,
          "If an account with that email exists " <>
          "reset instructions have been sent to you.")
        |> redirect(to: session_path(conn, :new))
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

  def password_reset(conn, _params), do: bad_link(conn)

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

  def unlock_account(conn, %{"token" => token}) do
    user = PhoenixBase.UserStore.find_by_unlock_token(token)

    if user do
      user
      |> PhoenixBase.User.unlock_account_changeset()
      |> PhoenixBase.Repo.update()
      |> case do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Your account has been successfully unlocked.")
        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Could not unlock account. " <>
              "Please try again or contact your administrator.")
      end
    else
      conn
      |> put_flash(:error, "Could not verify unlock token.")
    end
    |> redirect(to: session_path(conn, :new))
  end

  def unlock_account(conn, _params), do: bad_link(conn)

  defp bad_link(conn) do
    conn
    |> put_flash(:error, "Please be sure to follow the link in your email.")
    |> redirect(to: session_path(conn, :new))
  end
end
