defmodule PhoenixBase.UserHelper do
  import Guardian.Plug, only: [current_resource: 1]

  @moduledoc false

  def current_user(conn) do
    current_resource(conn)
  end

  def user_signed_in?(conn) do
    current_user(conn) != nil
  end

  def gravatar_url(conn, opts \\ []) do
    opts = [size: 200] |> Keyword.merge(opts) |> Enum.into(%{})

    "https://www.gravatar.com/avatar/#{current_user(conn).email
    |> md5_hash}?d=mm&s=#{opts.size}"
  end

  defp md5_hash(str) do
    :md5
    |> :crypto.hash(str)
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> :erlang.list_to_bitstring
  end
end
