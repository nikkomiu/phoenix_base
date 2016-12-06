defmodule AwesomeApp.ViewHelpers do
  def template_name(template) do
    template |> String.split(".") |> List.first()
  end
end
