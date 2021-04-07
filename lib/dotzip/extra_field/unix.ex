defmodule Dotzip.ExtraField.Unix do

  @moduledoc """
  
  This module encode and decode Unix extra field defined in section
  4.5.7 of the official documentation.

  """

  defstruct atime: 0, mtime: 0, uid: 0, gid: 0, var: 0
  
  defp tag() do
    <<0x00, 0x0d>>
  end
  
  defp encode_tag({:ok, data, buffer}) do
    {:ok, data, <<tag::binary-size(2), buffer::bitstring>>}
  end

  defp encode_tsize({:ok, data, buffer}) do
    s = byte_size(buffer)
    {:ok, data, <<s::size(16), buffer::bitstring>>}
  end

  defp encode_atime({:ok, %{ :atime => atime } = data, buffer}) do
    {:ok, data, <<atime::size(32), buffer::bitstring>>}
  end

  defp encode_mtime({:ok, %{ :mtime => mtime } = data, buffer}) do
    {:ok, data, <<mtime::size(32), buffer::bitstring>>}
  end

  defp encode_uid({:ok, %{ :uid => uid } = data, buffer}) do
    {:ok, data, <<uid::size(16), buffer::bitstring>>}
  end

  defp encode_gid({:ok, %{ :gid => gid } = data, buffer}) do
    {:ok, data, <<gid::size(16), buffer::bitstring>>}
  end

  defp encode_var(data) do
    {:ok, data, <<>>}
  end

  @doc """

  Encode an Unix Extra field.

  """
  def encode(data) do
    encode_var(data)
    |> encode_gid()
    |> encode_uid()
    |> encode_mtime()
    |> encode_atime()
    |> encode_tsize()
    |> encode_tag()
  end

  defp decode_tag(<<0x00, 0x0d, rest::bitstring>>) do
    {:ok, %{}, rest}
  end

  defp decode_tsize({:ok, data, <<tsize::size(16), rest::bitstring>>}) do
    {:ok, Map.put(data, :tsize, tsize), rest}
  end

  defp decode_atime({:ok, data, <<atime::size(32), rest::bitstring>>}) do
    {:ok, Map.put(data, :atime, atime), rest}
  end

  defp decode_mtime({:ok, data, <<mtime::size(32), rest::bitstring>>}) do
    {:ok, Map.put(data, :mtime, mtime), rest}
  end

  defp decode_uid({:ok, data, <<uid::size(16), rest::bitstring>>}) do
    {:ok, Map.put(data, :uid, uid), rest}
  end

  defp decode_gid({:ok, data, <<gid::size(16), rest::bitstring>>}) do
    {:ok, Map.put(data, :gid, gid ), rest}
  end

  defp decode_var({:ok, data, rest}) do
    {:ok, data, rest}
  end

  @doc """

  Decode an Unix Extra field.

  """
  
  def decode(bitstring) do
    decode_tag(bitstring)
    |> decode_tsize()
    |> decode_atime()
    |> decode_mtime()
    |> decode_uid()
    |> decode_gid()
    |> decode_var()
  end

end
