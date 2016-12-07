defmodule AwesomeApp.ViewHelpers do
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def is_user_signed_in?(conn) do
    current_user(conn) != nil
  end

  def format_date(date, format_string, method) do
    case Timex.format(date, format_string, method) do
      {:ok, str} ->
        {:safe, str}
      {:error, _} ->
        ""
    end
  end

  def template_name(template) do
    template |> String.split(".") |> List.first()
  end

  def gravatar_url(conn) do
    gravatar_url(conn, 200)
  end

  def gravatar_url(conn, size) do
    "https://www.gravatar.com/avatar/#{current_user(conn).email_md5}?d=mm&s=#{size}"
  end
end
