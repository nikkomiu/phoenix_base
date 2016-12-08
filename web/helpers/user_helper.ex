defmodule AwesomeApp.UserHelper do
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def is_user_signed_in?(conn) do
    current_user(conn) != nil
  end

  def gravatar_url(conn, opts \\ []) do
    opts = Keyword.merge([size: 200], opts) |> Enum.into(%{})
    "https://www.gravatar.com/avatar/#{current_user(conn).email_md5}?d=mm&s=#{opts.size}"
  end
end
