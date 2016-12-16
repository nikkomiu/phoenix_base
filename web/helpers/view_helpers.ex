defmodule PhoenixBase.ViewHelpers do
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

  def form_group(f, ele, [do: {:safe, do_content}]) do
    err = if f.errors[ele] != nil, do: " has-danger"

    { :safe, "<div class=\"form-group#{err}\">#{do_content}</div>"}
  end
#  <%= if message = f.errors[:email] do %>
#    <div class="form-control-feedback"><%= translate_error(message) %></div>
#  <% end %>
end
