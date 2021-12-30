defmodule Dotzip.ThirdParty.ExtendedTimestamp do

  @moduledoc ~S"""

  Extended Timestamp Extra Field Naive Implementation. This code is
  currently not safe. This module is a (really) low interface to
  generate extension.

  """

  @spec tag() :: bitstring()
  def tag(), do: <<0x55, 0x54>>

  @doc ~S"""
  See `decode/2` function.
  """
  @spec decode(bitstring()) :: {:ok, map(), bitstring()}
  def decode(data), do: decode(data, [])

  @doc ~S"""

  This code is currently not safe.

  ## Examples

      iex> Dotzip.ThirdParty.ExtendedTimestamp.decode(<<85, 84, 9, 0, 3, 78, 231, 202, 97, 78, 231, 202, 97>>)
      {:ok, %{ atime: ~U[2021-12-28 10:30:38Z], flags: %{atime: true, ctime: false, mtime: true}, mtime: ~U[2021-12-28 10:30:38Z],
               tsize: 9}, ""}

  """
  @spec decode(bitstring(), Keyword.t()) :: {:ok, map(), bitstring()}
  def decode(data, opts) do
    {struct, rest} = data
    |> decode_tag(opts)
    |> decode_tsize(opts)
    |> decode_flags(opts)
    |> decode_mtime(opts)
    |> decode_atime(opts)
    |> decode_ctime(opts)
    {:ok, struct, rest}
  end

  @doc ~S"""
  See `decode/2` function.
  """
  @spec decode!(bitstring()) :: {map(), bitstring()}
  def decode!(data), do: decode!(data, [])

  @doc ~S"""
  See `decode/2` function.
  """
  @spec decode!(bitstring(), Keyword.t()) :: {map(), bitstring()}
  def decode!(data, opts) do
    {:ok, struct, rest} = decode(data, opts)
    {struct, rest}
  end

  defp decode_tag(<<0x55, 0x54, rest :: bitstring>>, _opts) do
    {%{}, rest}
  end

  defp decode_tsize({struct, <<tsize :: little-size(16), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :tsize, tsize), rest}
  end

  defp decode_flags({struct, <<flags :: bitstring-little-size(8), rest :: bitstring>>}, _opts) do
    << _reserved :: size(5), ctime :: size(1), atime :: size(1), mtime :: size(1) >> = flags
    decoded = %{
      mtime: to_boolean(mtime),
      atime: to_boolean(atime),
      ctime: to_boolean(ctime)
    }
    {Map.put(struct, :flags, decoded), rest}
  end

  defp decode_mtime({%{ flags: %{ mtime: true } } = struct, <<mtime :: little-size(32), rest :: bitstring>>}, _opts) do
    {:ok, decoded} = DateTime.from_unix(mtime)
    {Map.put(struct, :mtime, decoded), rest}
  end
  defp decode_mtime({struct, rest}, _opts), do: {struct, rest}

  defp decode_atime({%{ flags: %{ atime: true } } = struct, <<atime :: little-size(32), rest :: bitstring>>}, _opts) do
    {:ok, decoded} = DateTime.from_unix(atime)
    {Map.put(struct, :atime, decoded), rest}
  end
  defp decode_atime({struct, rest}, _opts), do: {struct, rest}

  defp decode_ctime({%{ flags: %{ ctime: true }} = struct, <<ctime :: little-size(32), rest :: bitstring>>}, _opts) do
    {:ok, decoded} = DateTime.from_unix(ctime)
    {Map.put(struct, :ctime, decoded), rest}
  end
  defp decode_ctime({struct, rest}, _opts), do: {struct, rest}

  defp to_boolean(0), do: false
  defp to_boolean(1), do: true

  defp from_boolean(:false), do: 0
  defp from_boolean(:true), do: 1

  @doc ~S"""
  See `encode/2` function.
  """
  @spec encode(map()) :: {:ok, bitstring()}
  def encode(decoded), do: encode(decoded, [])

  @doc ~S"""

  Warning: This code is currently not safe.

  `encode/2` function encode a map structure in to bitstring.

  ## Examples

      iex> Dotzip.ThirdParty.ExtendedTimestamp.encode(%{ atime: 1640687438, flags: %{atime: true, ctime: false, mtime: true}, mtime: 1640687438}),
      {:ok, <<85, 84, 9, 0, 3, 78, 231, 202, 97, 78, 231, 202, 97>>}

  """
  @spec encode(map(), Keyword.t()) :: {:ok, bitstring()}
  def encode(decoded, opts) do
    {_, encoded} = decoded
    |> encode_tag(opts)
    |> encode_tsize(opts)
    |> encode_flags(opts)
    |> encode_mtime(opts)
    |> encode_atime(opts)
    |> encode_ctime(opts)
    {:ok, encoded}
  end

  @doc ~S"""
  See `encode/2` function.
  """
  @spec encode!(map()) :: bitstring()
  def encode!(decoded), do: encode(decoded, [])

  @doc ~S"""
  See `encode/2` function.
  """
  @spec encode!(map(), Keyword.t()) :: bitstring()
  def encode!(decoded, opts) do
    {:ok, encoded} = encode(decoded, opts)
    encoded
  end

  defp encode_tag(struct, _opts) do
    {struct, tag()}
  end

  @spec make_tsize(map(), integer()) :: integer()
  defp make_tsize(flags, init) do
    Enum.reduce(flags, init, fn
      ({_, true}, a) -> a+1
      ({_, false}, a) -> a
    end)
  end

  defp encode_tsize({ %{ flags: flags }= struct, buffer}, _opts) do
    tsize = (make_tsize(flags, 0)*4)+1
    {struct, <<buffer :: bitstring, tsize :: little-size(16)>>}
  end

  defp encode_flags({ %{ flags: %{ atime: atime, ctime: ctime, mtime: mtime } } = struct, buffer}, _opts) do
    activated = <<from_boolean(mtime) :: size(1), from_boolean(atime) :: size(1), from_boolean(ctime) :: size(1)>>
    {struct, <<buffer :: bitstring, 0 :: size(5), activated :: bitstring-size(3) >>}
  end

  defp encode_mtime({%{ flags: %{ mtime: true }, mtime: mtime } = struct, buffer}, _opts) do
    encoded = DateTime.to_unix(mtime)
    {struct, <<buffer :: bitstring, encoded :: little-size(32)>>}
  end
  defp encode_mtime({struct, rest}, _opts), do: {struct, rest}

  defp encode_atime({%{ flags: %{ atime: true }, atime: atime } = struct, buffer}, _opts) do
    encoded = DateTime.to_unix(atime)
    {struct, <<buffer :: bitstring, encoded :: little-size(32)>>}
  end
  defp encode_atime({struct, rest}, _opts), do: {struct, rest}

  defp encode_ctime({%{ flags: %{ ctime: true }, ctime: ctime} = struct, buffer}, _opts) do
    encoded = DateTime.to_unix(ctime)
    {struct, <<buffer :: bitstring, encoded :: little-size(32)>>}
  end
  defp encode_ctime({struct, rest}, _opts), do: {struct, rest}

end
