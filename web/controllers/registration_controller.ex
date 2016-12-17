defmodule PhoenixBase.RegistrationController do
  use PhoenixBase.Web, :controller

  alias PhoenixBase.User

  def new(conn, _params) do
    # TODO: Don't show registration page if logged in
    changeset = User.registration_changeset(%PhoenixBase.User{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset =
      %User{}
      |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> redirect(to: session_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
