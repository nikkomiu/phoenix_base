defmodule PhoenixBase.Auth.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Guardian.Plug, only: [sign_in: 2]

  alias PhoenixBase.Email.UserEmail
  alias PhoenixBase.Mailer
  alias PhoenixBase.Repo
  alias PhoenixBase.User
  alias PhoenixBase.UserLogin
  alias PhoenixBase.UserStore

  @moduledoc false

  def login_by_user_and_password(conn,
      %{"username" => username, "password" => pass}) do
    username
    |> UserStore.find_by_username_or_email()
    |> verify_access(pass)
    |> update_login_metrics(conn)
    |> case do
      {:ok, user} ->
        conn =
          conn
          |> sign_in(user)
          |> Plug.Conn.configure_session(renew: true)

        {:ok, conn}
      data ->
        data
    end
  end

  def forgot_password(conn, email) do
    conn
    |> forgot_password_check(UserStore.find_by_email(email))
  end

  def user_login_from_reset_token(token) do
    uuid = Ecto.UUID.cast(token)

    cond do
      uuid == :error ->
        {:error, :invalid_format}

      user_login = UserStore.find_user_login_by_reset_token(token) ->
        # TODO verify that the token has not passed the expiration time
        {:ok, user_login}

      true ->
        {:error, :not_found}
    end
  end

  defp update_login_metrics(tuple, conn) do
    case tuple do
      {:ok, user} ->
        user
        |> User.login_changeset(%{
          sign_in_count: (user.sign_in_count + 1),
          failed_attempts: 0
        }) |> Repo.update!

        {:ok, user}
      {:error, :unauthorized, user} ->
        changeset = User.login_changeset(user, %{
          failed_attempts: (user.failed_attempts + 1)
        })

        changeset |> Repo.update!

        case changeset do
          %Ecto.Changeset{changes: %{locked_at: _locked}} ->
            task = send_lock_out_email_async(conn, user.id)

            {:error, :locked, task}
          _ ->
            {:error, :unauthorized}
        end
      _ ->
        tuple
    end
  end

  defp forgot_password_check(conn, %User{} = user) do
    cond do
      user.locked_at != nil ->
        {:error, :locked_out}

      user.confirmed_at == nil ->
        {:error, :unconfimred}

      user.login ->
        changeset = UserLogin.reset_token_changeset(user.login)

        case Repo.update(changeset) do
          {:ok, user_login} ->
            task = send_reset_password_email_async(conn, user_login)

            {:ok, :scheduled, task}
          {:error, _} ->
            {:error, :update_token}
        end

      user.login == nil ->
        {:error, :no_password}
    end
  end

  defp forgot_password_check(_, _), do: {:error, :not_found}

  defp send_reset_password_email_async(conn, user_login) do
    Task.async fn ->
      conn
      |> UserEmail.user_reset_password_email(user_login.user_id)
      |> Mailer.deliver_now

      user_login
      |> UserLogin.email_changeset(%{reset_sent: Ecto.DateTime.utc})
      |> Repo.update!
    end
  end

  defp send_lock_out_email_async(conn, user_id) do
    Task.async fn ->
      conn
      |> UserEmail.user_locked_out_email(user_id)
      |> Mailer.deliver_now
    end
  end

  defp verify_access(%User{} = user, password) do
    cond do
      user.locked_at != nil ->
        {:error, :locked, nil}
      user.confirmed_at == nil ->
        {:error, :unconfirmed}
      user.login && checkpw(password, user.login.encrypted_password) ->
        {:ok, user}
      true ->
        {:error, :unauthorized, user}
    end
  end

  defp verify_access(_, _) do
    dummy_checkpw()

    {:error, :not_found}
  end
end
