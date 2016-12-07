defmodule AwesomeApp.ModelHelpers do
  def md5_hash(str) do
    :crypto.hash(:md5, str)
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> :erlang.list_to_bitstring
  end
end
