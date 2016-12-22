defmodule PhoenixBase.AuthTest do
  use PhoenixBase.ConnCase
  use Bamboo.Test, shared: true

  alias PhoenixBase.Auth
  alias PhoenixBase.TestHelpers

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PhoenixBase.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  describe "login_by_user_and_password/2" do
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
      assert {:error, :not_found} =
        Auth.login_by_user_and_password(build_conn, %{"username" => "me", "password" => "wrong"})
    end

    test "login with password mismatch", %{conn: conn} do
      user = TestHelpers.insert_user()
      _ = TestHelpers.insert_user_login(user, %{password: "R!ghtP@ss1", password_confirmation: "R!ghtP@ss1"})

      assert {:error, :unauthorized} =
        Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => "wrong"})
    end

    test "login with too many failed attempts", %{conn: conn} do
      user = TestHelpers.insert_user()
      _ = TestHelpers.insert_user_login(user, %{password: "R!ghtP@ss1", password_confirmation: "R!ghtP@ss1"})

      task =
        for _ <- 1..5 do
          Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => "wrong"})
        end
        |> List.last

      assert {:error, :locked, _} = task
    end

    test "login with too many failed attempts sent lock out email", %{conn: conn} do
      user = TestHelpers.insert_user()
      _ = TestHelpers.insert_user_login(user, %{password: "R!ghtP@ss1", password_confirmation: "R!ghtP@ss1"})

      for _ <- 1..10 do
        case Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => "wrong"}) do
          {:error, :locked, task} ->
            task
          _ ->
            nil
        end
      end
      |> List.last
      |> IO.puts

      assert_delivered_email PhoenixBase.Email.user_locked_out_email(conn, user.id)
    end

    test "login with locked account", %{conn: conn} do
      user = TestHelpers.insert_user(locked_at: Ecto.DateTime.utc)
      user_login = TestHelpers.insert_user_login(user)

      assert {:error, :locked, _conn} =
        Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => user_login.password})
    end

    test "login with unconfirmed account", %{conn: conn} do
      user = TestHelpers.insert_user(confirmed_at: nil)

      assert {:error, :unconfirmed} =
        Auth.login_by_user_and_password(conn, %{"username" => user.username, "password" => "anypassword"})
    end
  end

  describe "forgot_password/2" do
    test "forgot password with valid email", %{conn: conn} do
      user = TestHelpers.insert_user()
      _ = TestHelpers.insert_user_login(user)

      assert {:ok, :scheduled, _} = Auth.forgot_password(conn, user.email)
    end

    test "forgot password sends email to user with token", %{conn: conn} do
      user = TestHelpers.insert_user()
      _ = TestHelpers.insert_user_login(user)

      {:ok, :scheduled, _} = Auth.forgot_password(conn, user.email)

      assert_delivered_email PhoenixBase.Email.user_reset_password_email(conn, user.id)
    end

    test "forgot password sets email sent with valid email", %{conn: conn} do
      user = TestHelpers.insert_user()
      user_login = TestHelpers.insert_user_login(user)

      {:ok, :scheduled, task} = Auth.forgot_password(conn, user.email)

      Task.await(task)

      assert TestHelpers.find_user_login_by_id(user_login.id).reset_sent != nil
    end

    test "forgot password with invalid email", %{conn: conn} do
      _ = TestHelpers.insert_user(email: "some@somewhere.com")

      assert {:error, :not_found} = Auth.forgot_password(conn, "notme@some.com")
    end

    test "forgot password with unconfirmed account", %{conn: conn} do
      user = TestHelpers.insert_user(confirmed_at: nil)

      assert {:error, :unconfimred} = Auth.forgot_password(conn, user.email)
    end

    test "forgot password with locked account", %{conn: conn} do
      user = TestHelpers.insert_user(locked_at: Ecto.DateTime.utc)

      assert {:error, :locked_out} = Auth.forgot_password(conn, user.email)
    end
  end

  describe "user_login_from_reset_token/1" do
    test "get user login from reset token with valid token" do
      user_login =
        TestHelpers.insert_user()
        |> TestHelpers.insert_user_login(should_reset: true)

      {:ok, res} = Auth.user_login_from_reset_token(user_login.reset_token)

      assert user_login.id == res.id
    end

    test "get user login from reset token with invalid token" do
      _ =
        TestHelpers.insert_user()
        |> TestHelpers.insert_user_login(should_reset: true)

      assert {:error, :not_found} = Auth.user_login_from_reset_token(Ecto.UUID.generate)
    end

    test "get user login from reset token with garbage token" do
      _ =
        TestHelpers.insert_user()
        |> TestHelpers.insert_user_login(should_reset: true)

      assert {:error, :invalid_format} = Auth.user_login_from_reset_token("myawesomefaketoken")
    end
  end
end
