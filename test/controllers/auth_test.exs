defmodule AwesomeApp.AuthTest do
  use AwesomeApp.ConnCase

  alias AwesomeApp.Auth
  alias AwesomeApp.TestHelpers

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(AwesomeApp.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "login with valid username and password", %{conn: conn} do
    user = TestHelpers.insert_user(username: "test.user", password: "rightpassword")

    {:ok, conn} =
      Auth.login_by_username_and_password(conn, "test.user", "rightpassword")

    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "login with not found user", %{conn: _conn} do
    assert {:error, :not_found, _conn} =
      Auth.login_by_username_and_password(build_conn, "me", "wrong")
  end

  test "login with password mismatch", %{conn: conn} do
    _ = TestHelpers.insert_user(username: "test.user", password: "rightpassword")

    assert {:error, :unauthorized, _conn} =
      Auth.login_by_username_and_password(conn, "test.user", "wrong")
  end
end
