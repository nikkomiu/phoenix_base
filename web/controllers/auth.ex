defmodule PhoenixBase.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Guardian.Plug, only: [sign_in: 2]

  alias PhoenixBase.Repo
  alias PhoenixBase.User
  alias PhoenixBase.UserStore

  @moduledoc false

  def login_by_user_and_password(conn,
      %{"username" => username, "password" => pass}) do
    username
    |> UserStore.find_by_username_or_email()
    |> verify_access(pass)
    |> update_login_metrics
    |> case do
      {:ok, user} ->
        {:ok, sign_in(conn, user)}
      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  def forgot_password(email) do
    UserStore.find_by_email(email)
    # TODO: Send Forgot Password Email
  end

  defp update_login_metrics(tuple) do
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
            # TODO: Send Locked Out Email
            {:error, :locked}
          _ ->
            {:error, :unauthorized}
        end
      _ ->
        tuple
    end
  end

  defp verify_access(user, password) do
    cond do
      user && user.locked_at != nil ->
        {:error, :locked}
      user && user.confirmed_at != nil ->
        {:error, :unconfirmed}
      user && checkpw(password, user.user_login.encrypted_password) ->
        {:ok, user}
      user ->
        {:error, :unauthorized, user}
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end
end
