defmodule PhoenixBase.RegistrationController do
  use PhoenixBase.Web, :controller

  alias PhoenixBase.Email
  alias PhoenixBase.Mailer
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
      {:ok, user} ->
        Task.async fn ->
          conn
          |> Email.user_registration_confirmation_email(user.id)
          |> Mailer.deliver_now
        end

        conn
        |> put_flash(:info, "Please check your email for confirmation instructions.")
        |> redirect(to: session_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def complete_registration(%{method: "GET"} = conn, %{"token" => token}) do
    user = PhoenixBase.UserStore.find_by_confirmation_token(token)

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset()

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
    user = PhoenixBase.UserStore.find_by_confirmation_token(token)

    if user do
      changeset =
        user
        |> Ecto.build_assoc(:login)
        |> UserLogin.registration_changeset(login_params)

      case Repo.insert(changeset) do
        {:ok, _user_login} ->
          conn
          |> put_flash(:info, "Your account has been confirmed, you can now log in.")
          |> redirect(to: session_path(conn, :new))
        {:error, changeset} ->
          conn
          |> render("complete_registration.html", changeset: changeset, token: token)
      end
    else
      conn
      |> render("complete_registration.html", changeset: changeset, token: token)
    end
  end
end
