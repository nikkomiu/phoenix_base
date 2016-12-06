defmodule AwesomeApp.ViewHelpers do
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def is_user_signed_in?(conn) do
    current_user(conn) != nil
  end

  def template_name(template) do
    template |> String.split(".") |> List.first()
  end
end
