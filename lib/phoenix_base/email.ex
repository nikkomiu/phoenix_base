defmodule PhoenixBase.Email do
  use Bamboo.Phoenix, view: PhoenixBase.EmailView

  alias PhoenixBase.User
  alias PhoenixBase.UserLogin

  @moduledoc false

  def user_reset_password_email(conn, user_id) do
    user = PhoenixBase.UserStore.find_by_id(user_id)

    user.email
    |> setup
    |> subject("Finish Resetting your Phoenix Base Password")
    |> render("reset_password.html", conn: conn, user: user)
  end

  def user_registration_confirmation_email(conn, user_id) do
    user = PhoenixBase.UserStore.find_by_id(user_id)

    user.email
    |> setup
    |> subject("Confirm Your Phoenix Base Account")
    |> render("registration_confirmation.html", conn: conn, user: user)
  end

  defp setup(email_address) do
    new_email
    |> to(email_address)
    |> from("no-reply@nikkomiu.com")
    |> put_html_layout({PhoenixBase.LayoutView, "email.html"})
  end
end
