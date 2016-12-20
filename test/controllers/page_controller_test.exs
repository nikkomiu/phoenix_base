defmodule PhoenixBase.PageControllerTest do
  use PhoenixBase.ConnCase

  test "homepage", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "about page", %{conn: conn} do
    conn = get conn, "/about"

    assert html_response(conn, 200) =~ "about page"
  end
end
