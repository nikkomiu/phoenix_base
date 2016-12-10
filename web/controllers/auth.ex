defmodule AwesomeApp.Auth do
  alias AwesomeApp.Repo

  import Ecto.Query
  import Comeonin.Bcrypt

  def login_by_username_and_password(conn, username, password) do
    query = from u in AwesomeApp.User,
      where: u.email == ^username or u.username == ^username

    Repo.one(query)
    |> verify_access(password)
    |> update_login_metrics(conn)
    |> case do
      {:ok, user} ->
        {:ok, Guardian.Plug.sign_in(conn, user)}
      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  def forgot_password(conn, email) do
    query = from u in AwesomeApp.User,
      where: u.email == ^email

    # Send Email

    # Update DB
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
      # User is locked
      user && user.locked_at != nil ->
        {:error, :locked}
      # User is unconfirmed
      user && user.confirmed_at == nil ->
        {:error, :unconfirmed}
      # User has correct password
      user && checkpw(password, user.encrypted_password) ->
        {:ok, user}
      # User has incorrect password
      user ->
        {:error, :unauthorized, user}
      # No User
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  defp update_login_metrics(tuple, conn) do
    case tuple do
      {:ok, user} ->
        AwesomeApp.User.login_changeset(user, %{
          sign_in_count: (user.sign_in_count + 1),
          failed_attempts: 0
        }) |> Repo.update!

        {:ok, user}
      {:error, :unauthorized, user} ->
        AwesomeApp.User.login_changeset(user, %{
          failed_attempts: (user.failed_attempts + 1)
        }) |> Repo.update!

        # TODO: Send Unlock Email

        {:error, :unauthorized}
      _ ->
        tuple
    end
  end

  defp send_email_for_changeset(conn, changeset, user) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{reset_password_token: token}} ->
        Task.async fn ->
          AwesomeApp.Email.user_reset_password_email(conn, user.email, token)
          |> AwesomeApp.Mailer.deliver_now

          AwesomeApp.User.email_changeset(user, %{reset_password_sent_at: Ecto.DateTime.utc})
          |> Repo.update!
        end

        {:ok, :email_scheduled}
      %Ecto.Changeset{valid?: true, changes: %{unlock_token: token}} ->
        Task.async fn ->
          AwesomeApp.Email.user_reset_password_email(conn, user.email, token)
          |> AwesomeApp.Mailer.deliver_now

          # TODO: Add unlock_sent_at to DB
          # AwesomeApp.User.email_changeset(user, %{unlock_sent_at: Ecto.DateTime.utc})
          # |> Repo.update!
        end

        {:ok, :email_scheduled}
      %Ecto.Changeset{valid?: true, changes: %{confirmation_token: token}} ->
        Task.async fn ->
          AwesomeApp.Email.user_reset_password_email(conn, user.email, token)
          |> AwesomeApp.Mailer.deliver_now

          AwesomeApp.User.email_changeset(user, %{confirmation_sent_at: Ecto.DateTime.utc})
          |> Repo.update!
        end

        {:ok, :email_scheduled}
      _ ->
        {:error, :no_acton_nescessary}
    end
  end
end
