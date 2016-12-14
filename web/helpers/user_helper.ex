defmodule AwesomeApp.UserHelper do
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def user_signed_in?(conn) do
    current_user(conn) != nil
  end

  def gravatar_url(conn, opts \\ []) do
    opts = Keyword.merge([size: 200], opts) |> Enum.into(%{})
    "https://www.gravatar.com/avatar/#{current_user(conn).email |> md5_hash}?d=mm&s=#{opts.size}"
  end

  defp md5_hash(str) do
    :crypto.hash(:md5, str)
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> :erlang.list_to_bitstring
  end
end
