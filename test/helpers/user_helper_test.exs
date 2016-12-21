defmodule PhoenixBase.UserHelperTest do
  use PhoenixBase.ConnCase

  alias PhoenixBase.User
  alias PhoenixBase.TestHelpers
  alias PhoenixBase.UserHelper

  setup %{conn: conn} = config do
    conn =
      conn
      |> bypass_through(PhoenixBase.Router, :browser)
      |> get("/")

    if email = config[:login_as] do
      u = TestHelpers.insert_user(email: email)

      {:ok, %{
        conn: Guardian.Plug.sign_in(conn, u),
        user: u
      }}
    else
      {:ok, %{conn: conn}}
    end
  end

  describe "current_user/2" do
    @tag login_as: "awesome_user@some.com"
    test "get current user with user set", %{conn: conn, user: user} do
      assert UserHelper.current_user(conn).id == user.id
    end

    test "get current user with no user set", %{conn: conn} do
      assert UserHelper.current_user(conn) == nil
    end

    @tag login_as: "awesome_user@some.com"
    test "get current user with default and user set", %{conn: conn, user: user} do
      assert UserHelper.current_user(conn, default: %User{}).id == user.id
    end

    test "get current user with default and no user set", %{conn: conn} do
      assert UserHelper.current_user(conn, default: %User{id: -1}).id == -1
    end
  end

  describe "user_signed_in?/1" do
    @tag login_as: "awesome_user@some.com"
    test "user is signed in", %{conn: conn, user: _} do
      assert UserHelper.user_signed_in?(conn) == true
    end

    test "user is not signed in", %{conn: conn} do
      assert UserHelper.user_signed_in?(conn) == false
    end
  end

  describe "gravatar_url/2" do
    @tag login_as: "awesome_user@some.com"
    test "gravatar url with current user set", %{conn: conn, user: user} do
      assert UserHelper.gravatar_url(conn) =~
        "avatar/" <> UserHelper.md5_hash(user.email)
    end

    test "gravatar url with no current user set", %{conn: conn} do
      assert UserHelper.gravatar_url(conn) =~
        "avatar/" <> UserHelper.md5_hash("")
    end

    @tag login_as: "awesome_user@some.com"
    test "gravatar url with user passed", %{conn: conn} do
      email = "otheruser@some.com"

      assert UserHelper.gravatar_url(conn, user: %User{email: email}) =~
        "avatar/" <> UserHelper.md5_hash(email)
    end

    @tag login_as: "awesome_user@some.com"
    test "gravatar url with size passed", %{conn: conn, user: _} do
      assert UserHelper.gravatar_url(conn, size: 50) =~ "s=50"
    end
  end
end
