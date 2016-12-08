defmodule AwesomeApp.AccountSettingsController do
  use AwesomeApp.Web, :controller

  def index(conn, _params), do:
    conn |> redirect(to: account_settings_path(conn, :profile))

  def profile(conn, _params) do
    changeset = AwesomeApp.User.profile_changeset(current_user(conn))

    conn
    |> render("profile.html", changeset: changeset)
  end

  def update_profile(conn, %{"user" => user_params}) do
    changeset =
      AwesomeApp.User.profile_changeset(current_user(conn), user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully updated profile.")
        |> render("profile.html", changeset: changeset)
      {:error, changeset} ->
        conn
        |> render("profile.html", changeset: changeset)
    end
  end

  def account(conn, _params) do
    conn
    |> render("account.html")
  end

  def update_password(conn, %{"password" => user_params}) do

  end

  def emails(conn, _params) do
    conn
    |> render("emails.html")
  end

  def phones(conn, _params) do
    conn
    |> render("phones.html")
  end
end
