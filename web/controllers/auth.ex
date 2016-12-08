defmodule AwesomeApp.Auth do

  alias AwesomeApp.Repo

  import Ecto.Query
  import Comeonin.Bcrypt

  def login_by_username_and_password(conn, username, password) do
    find_by_email_or_username(username)
    |> verify_password(password)
    |> case do
      {:ok, user} ->
        {:ok, login(conn, user)}
      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  def update_password_for_user(user, old_pass, new_pass) do
    # Verify old_pass is correct
    case verify_password(user, old_pass) do
      {:ok, user} ->
        # Set new pass
        %AwesomeApp.User{}
        |> AwesomeApp.User.registration_changeset(%{password: new_pass})
        |> Repo.update()
      {:error, reason} ->
        {:error, reason}
    end
  end

  def verify_password(user, password) do
    cond do
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
