defmodule PhoenixBase.SessionControllerTest do
  use PhoenixBase.ConnCase
  use Bamboo.Test, shared: true

  alias PhoenixBase.TestHelpers

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PhoenixBase.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  describe "new/2" do
    test "get login page", %{conn: conn} do
      conn = get(conn, session_path(conn, :new))

      assert html_response(conn, 200) =~ "Sign in</button>"
    end

    # test "get login page when logged in"
  end

  describe "delete/2" do

  end

  describe "unauthenticated/2" do

  end

  describe "already_authenticated/2" do

  end
end
