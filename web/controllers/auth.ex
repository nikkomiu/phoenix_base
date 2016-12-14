defmodule AwesomeApp.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def login_by_username_and_password(conn, %{"username" => username, "password" => pass}) do
    AwesomeApp.UserStore.find_by_username_or_email(username)
    |> verify_access(pass)
    |> update_login_metrics
    |> case do
      {:ok, user} ->
        {:ok, Guardian.Plug.sign_in(conn, user)}
      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  defp update_login_metrics(tuple) do
    case tuple do
      {:ok, user} ->
        AwesomeApp.User.login_changeset(user, %{
          sign_in_count: (user.sign_in_count + 1),
          failed_attempts: 0
        }) |> AwesomeApp.Repo.update!

        {:ok, user}
      {:error, :unauthorized, user} ->
        changeset = AwesomeApp.login_changeset(user, %{
          failed_attempts: (user.failed_attempts + 1)
        })

        changeset |> AwesomeApp.Repo.update!

        case changeset do
          %Ecto.Changeset{changes: %{locked_at: _locked}} ->
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
