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

  def update_profile(conn, %{"user" => %{"email" => email} = user_params}) do
    user = current_user(conn)

    user_params =
      if user.email != email do
        user_params
        |> Map.delete("email")
        |> Map.put("unverified_email", email)
      else
        user_params
      end

    changeset = AwesomeApp.User.profile_changeset(user, user_params)


    case AwesomeApp.Repo.update(changeset) do
      {:ok, u} ->
        # TODO: Send email confirmation if email changed

        conn
        |> put_flash(:info, "Successfully updated your profile.")
        |> render("profile.html", user: u, changeset: changeset)
      {:error, c} ->
        conn
        |> render("profile.html", user: user, changeset: c)
    end
  end

  def account(conn, _params) do
    conn
    |> render("account.html")
  end
end
