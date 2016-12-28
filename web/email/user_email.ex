defmodule PhoenixBase.Email.UserEmail do
  use Bamboo.Phoenix, view: PhoenixBase.Email.UserView

  alias PhoenixBase.UserStore

  @moduledoc false

  def user_reset_password_email(conn, user_id) do
    user = UserStore.find_by_id(user_id)

    user.email
    |> setup
    |> subject("Finish resetting your Phoenix Base password")
    |> render("reset_password.html", conn: conn, user: user)
  end

  def user_registration_confirmation_email(conn, user_id) do
    user = UserStore.find_by_id(user_id)

    user.email
    |> setup
    |> subject("Confirm your Phoenix Base account")
    |> render("registration_confirmation.html", conn: conn, user: user)
  end

  def user_locked_out_email(conn, user_id) do
    user = UserStore.find_by_id(user_id)

    user.email
    |> setup
    |> subject("You have been locked out of your Phoenix Base account")
    |> render("locked_out.html", conn: conn, user: user)
  end

  defp setup(email_address) do
    new_email
    |> to(email_address)
    |> from("no-reply@nikkomiu.com")
    |> put_html_layout({PhoenixBase.LayoutView, "email.html"})
  end
end
