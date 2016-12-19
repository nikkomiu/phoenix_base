defmodule PhoenixBase.RegistrationController do
  use PhoenixBase.Web, :controller

  alias PhoenixBase.User
  alias PhoenixBase.UserLogin

  def new(conn, _params) do
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

  def complete_registration(%{method: "GET"} = conn, %{"token" => token}) do
    # TODO Verify token

    changeset = UserLogin.registration_changeset(%UserLogin{user_id: 1})

    conn
    |> render("complete_registration.html", changeset: changeset, token: token)
  end

  def complete_registration(%{method: "GET"} = conn, _params) do
    conn
    |> put_flash(:error, "Please be sure to follow the link in your email.")
    |> redirect(to: session_path(conn, :new))
  end

  def complete_registration(%{method: "POST"} = conn,
      %{"user_login" => %{"token" => token} = login_params}) do
    # TODO Verify token

    changeset = UserLogin.registration_changeset(
      %UserLogin{user_id: 1}, login_params
    )

    conn
    |> render("complete_registration.html", changeset: changeset, token: token)
  end
end
