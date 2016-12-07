defmodule AwesomeApp.AccountSettingsController do
  use AwesomeApp.Web, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: account_settings_path(conn, :profile))
  end

  def profile(conn, _params) do
    conn
    |> render("profile.html")
  end

  def account(conn, _params) do
    conn
    |> render("account.html")
  end

  def emails(conn, _params) do
    conn
    |> render("emails.html")
  end

  def phones(conn, _params) do
    conn
    |> render("phones.html")
  end
end
