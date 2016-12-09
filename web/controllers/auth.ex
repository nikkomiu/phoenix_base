defmodule AwesomeApp.Auth do

  alias AwesomeApp.Repo

  import Ecto.Query
  import Comeonin.Bcrypt

  def login_by_username_and_password(conn, username, password) do
    find_by_email_or_username(username)
    |> verify_access(password)
    |> case do
      {:ok, user} ->
        AwesomeApp.User.login_changeset(user, %{
          number_of_logins: (user.number_of_logins + 1),
          login_attempts: 0
        })
        {:ok, login(conn, user)}
      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  def update_password_for_user(user, old_pass, new_pass) do
    # Verify old_pass is correct
    case verify_access(user, old_pass) do
      {:ok, user} ->
        # Set new pass
        %AwesomeApp.User{}
        |> AwesomeApp.User.registration_changeset(%{password: new_pass})
        |> Repo.update()
      {:error, reason} ->
        {:error, reason}
    end
  end

  def verify_access(user, password) do
    cond do
      user && user.locked == true ->
        {:error, :locked}
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  defp login(conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end

  defp find_by_email_or_username(field) do
    Repo.one from u in AwesomeApp.User,
      where: u.email == ^field or u.username == ^field
  end
end
