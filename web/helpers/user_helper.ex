defmodule PhoenixBase.UserHelper do
  import Guardian.Plug, only: [current_resource: 1]

  @moduledoc false

  def current_user(conn, opts \\ %{}) do
    current_resource(conn) || opts[:default]
  end

  def user_signed_in?(conn) do
    current_user(conn) != nil
  end

  def gravatar_url(conn, opts \\ []) do
    opts = [size: 200] |> Keyword.merge(opts) |> Enum.into(%{})

    "https://www.gravatar.com/avatar/" <>
    (cond do
      user = opts[:user] ->
        user.email
      user = current_user(conn) ->
        user.email
      true ->
        ""
    end
    |> md5_hash)
    <> "?d=mm&s=#{opts.size}"
  end

  def md5_hash(str) do
    :md5
    |> :crypto.hash(str)
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> :erlang.list_to_bitstring
  end
end
