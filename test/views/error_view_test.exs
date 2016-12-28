defmodule PhoenixBase.ErrorViewTest do
  use PhoenixBase.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(PhoenixBase.ErrorView, "404.html", []) =~
           "(404)"
  end

  test "render 500.html" do
    assert render_to_string(PhoenixBase.ErrorView, "500.html", []) =~
           "(500)"
  end

  test "render any other" do
    assert render_to_string(PhoenixBase.ErrorView, "505.html", []) =~
           "(500)"
  end
end
