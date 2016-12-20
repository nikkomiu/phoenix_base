defmodule PhoenixBase.PageControllerTest do
  use PhoenixBase.ConnCase

  describe "index/2" do
    test "homepage", %{conn: conn} do
      conn = get conn, "/"
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end
  end

  describe "about/2" do
    test "about page", %{conn: conn} do
      conn = get conn, "/about"

      assert html_response(conn, 200) =~ "about page"
    end
  end
end
