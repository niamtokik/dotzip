defmodule Dotzip.ExtraField.UnixTest do
  use ExUnit.Case, async: true
  doctest Dotzip.ExtraField.Unix

  # test "decode an empty Unix field" do
  #   struct = %{atime: 0, gid: 0, mtime: 0, uid: 0, tsize: 12}
  #   {:ok, struct, data} = Dotzip.ExtraField.Unix.encode(struct)
  #   {:ok, decoded_struct, _decoded_data} = Dotzip.ExtraField.Unix.decode(data)
  #   assert struct == decoded_struct
  # end

  # test "encode an empty Unix field" do
  #   data = <<0, 13, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>
  #   {:ok, decoded_struct, _} = Dotzip.ExtraField.Unix.decode(data)
  #   {:ok, struct, _encoded_data} = Dotzip.ExtraField.Unix.encode(decoded_struct)
  #   assert struct == decoded_struct
  # end

end
