defmodule AwesomeApp.RegistrationController do
  use AwesomeApp.Web, :controller

  def new(conn, _params) do
    # TODO: Don't show registration page if logged in
    changeset = AwesomeApp.User.registration_changeset(%AwesomeApp.User{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = AwesomeApp.User.registration_changeset(%AwesomeApp.User{}, user_params)

    case AwesomeApp.Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> redirect(to: session_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
