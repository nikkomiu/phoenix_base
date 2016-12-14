defmodule AwesomeApp.AccountSettingsController do
  use AwesomeApp.Web, :controller

  def index(conn, _params), do:
    conn |> redirect(to: account_settings_path(conn, :profile))

  def profile(conn, _params) do
    user = current_user(conn)
    changeset = AwesomeApp.User.profile_changeset(user)

    conn
    |> render("profile.html", user: user, changeset: changeset)
  end

  def update_profile(conn, %{"user" => user_params}) do
    user = current_user(conn)
    changeset = AwesomeApp.User.profile_changeset(user, user_params)

    data =
      case AwesomeApp.Repo.update(changeset) do
        {:ok, u} ->
          conn =
            conn
            |> put_flash(:info, "Successfully updated your profile.")

          %{user: u, changeset: changeset}
        {:error, c} ->
          %{user: user, changeset: c}
      end

    conn
    |> render("profile.html", data)
  end

  def account(conn, _params) do
    conn
    |> render("account.html")
  end
end
