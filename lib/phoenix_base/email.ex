defmodule PhoenixBase.Email do
  use Bamboo.Phoenix, view: PhoenixBase.EmailView

  @moduledoc false

  def user_reset_password_email(conn, email_address, reset_token) do
    new_email
    |> to(email_address)
    |> from("no-reply@nikkomiu.com")
    |> subject("Finish Resetting your Phoenix Base Password")
    |> put_html_layout({PhoenixBase.LayoutView, "email.html"})
    |> render("reset_password.html", conn: conn, reset_token: reset_token)
  end
end
