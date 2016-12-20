defmodule PhoenixBase.AuthTest do
  use PhoenixBase.ConnCase

  alias PhoenixBase.Auth
  alias PhoenixBase.TestHelpers

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PhoenixBase.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "login with valid username and password", %{conn: conn} do
    user = TestHelpers.insert_user()
    user_login = TestHelpers.insert_user_login(user)

    {:ok, conn} =
      Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => user_login.password})

    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "login with valid email and password", %{conn: conn} do
    user = TestHelpers.insert_user()
    user_login = TestHelpers.insert_user_login(user)

    {:ok, _conn} =
      Auth.login_by_user_and_password(conn, %{"username" => user.email, "password" => user_login.password})
  end

  test "login with not found user", %{conn: _conn} do
    assert {:error, :not_found, _conn} =
      Auth.login_by_user_and_password(build_conn, %{"username" => "me", "password" => "wrong"})
  end

  test "login with password mismatch", %{conn: conn} do
    user = TestHelpers.insert_user()
    _ = TestHelpers.insert_user_login(user, %{password: "rightpassword", password_confirmation: "rightpassword"})

    assert {:error, :unauthorized, _conn} =
      Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => "wrong"})
  end

  test "login with locked account", %{conn: conn} do
    user = TestHelpers.insert_user(locked_at: Ecto.DateTime.utc)
    user_login = TestHelpers.insert_user_login(user)

    assert {:error, :locked, _conn} =
      Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => user_login.password})
  end

  test "login with unconfirmed account", %{conn: conn} do
    user = TestHelpers.insert_user(confirmed_at: nil)

    assert {:error, :unconfirmed, _conn} =
      Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => "anypassword"})
  end
end
