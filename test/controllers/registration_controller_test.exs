defmodule PhoenixBase.RegistrationControllerTest do
  use PhoenixBase.ConnCase
  use Bamboo.Test, shared: true

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PhoenixBase.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  describe "new/2" do
    test "get registration page", %{conn: conn} do
      conn = get(conn, registration_path(conn, :new))

      assert html_response(conn, 200) =~ "Register</button>"
    end

    # test "get registration page when logged in"
  end

  describe "create/2" do
    test "register user with valid attributes", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create), user: %{
        name: "Test User",
        username: "test.user",
        email: "test.user@test.com"
      })

      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "register user with valid attributes sends email", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create), user: %{
        name: "Test User",
        username: "test.user",
        email: "test.user@test.com"
      })

      user = PhoenixBase.UserStore.find_by_email("test.user@test.com")

      assert_delivered_email PhoenixBase.Email.UserEmail.user_registration_confirmation_email(conn, user.id)
    end

    # test "register user without name"

    # test "register user without username"

    # test "register user with taken username"

    # test "register user without email"

    # test "register user with email taken"

    # test "register user when logged in"
  end

  describe "GET complete_registration/2" do
    # test "get complete registration without token"

    # test "get complete registration with garbage token"

    # test "get complete registration with invalid token"

    # test "get complete registration with valid token"

    # test "get complete registration when logged in"
  end

  describe "POST complete_registration/2" do
    # test "complete registration with valid token and no password"

    # test "complete registration with valid token and valid password"

    # test "complete registration with valid token and password too short"

    # test "complete registration with valid token and password too long"

    # test "complete registration with valid token and password without uppercase letter"

    # test "complete registration with valid token and password without lowercase letter"

    # test "complete registration with valid token and password without number"

    # test "complete registration without token"

    # test "complete registration with garbage token"

    # test "complete registration with invalid token"

    # test "complete registration when logged in"
  end
end
