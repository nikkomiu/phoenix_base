defmodule PhoenixBase.RegistrationController do
  use PhoenixBase.Web, :controller

  def new(conn, _params) do
    # TODO: Don't show registration page if logged in
    changeset = PhoenixBase.User.registration_changeset(%PhoenixBase.User{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = PhoenixBase.User.registration_changeset(%PhoenixBase.User{}, user_params)

    case PhoenixBase.Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> redirect(to: session_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
