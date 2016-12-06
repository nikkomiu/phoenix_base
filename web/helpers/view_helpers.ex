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
end
