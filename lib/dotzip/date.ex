defmodule Dotzip.Date do

  @moduledoc """

  This module implement MS-DOS Date format. Here some source if you
  want Microsoft Date Format specification:

    - https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-dosdatetimetofiletime?redirectedfrom=MSDN
    - https://docs.microsoft.com/en-us/cpp/c-runtime-library/32-bit-windows-time-date-formats?view=msvc-170

  """

  @doc ~S"""

  `decode/1` function decode a binary string and convert it in
  `Date.t()` data type.

  ## Examples

      iex> Dotzip.Date.decode(<<0x9c, 0x53>>)
      {:ok, ~D[2021-12-28]}

  """
  @spec decode(bitstring()) :: {:ok, Date.t()}
  def decode(<<lsb::size(8), msb::size(8)>> = _bitstring) do
    <<offset::little-size(7), month::little-size(4), day::little-size(5)>> = <<msb, lsb>>
    Date.new(1980+offset, month, day)
  end

  @doc ~S"""

  `decode!/1` function decode a binary string and convert it in
  `Date.t()` data type.

  ## Examples

      iex> Dotzip.Date.decode!(<<0x9c, 0x53>>)
      ~D[2021-12-28]

  """
  @spec decode!(bitstring()) :: Date.t()
  def decode!(bitstring) do
    {:ok, decoded} = decode(bitstring)
    decoded
  end

  @doc ~S"""

  `encode/1` function encode a `Date.t()` type into MS-DOS Date
  Format.

  ## Examples

      iex> Dotzip.Date.encode(~D[2021-12-28])
      {:ok, <<156, 83>>}

  """
  @spec encode(Date.t()) :: {:ok, bitstring()}
  def encode(date) do
    case date.year >= 1980 and date.year <= 2107 do
      true ->
        day = date.day
        month = date.month
        offset = date.year - 1980
        <<lsb::size(8), msb::size(8)>> = <<offset::size(7), month::size(4), day::size(5)>>
        {:ok, <<msb, lsb>>}
      false ->
        {:error, "year is less than 1980 or greater than 2108"}
    end
  end

  @doc ~S"""

  `encode!/1` function encode a `Date.t()` type into MS-DOS Date
  Format.

  ## Examples

      iex> Dotzip.Date.encode!(~D[2021-12-28])
      <<156, 83>>

  """
  @spec encode!(Date.t()) :: bitstring()
  def encode!(date) do
    {:ok, encoded} = encode(date)
    encoded
  end

  @doc ~S"""

  `encode/3` function encode year, month and day in MS-DOS Date
  Format.

  ## Examples

      iex> Dotzip.Date.encode(2021,12,28)
      {:ok, <<156, 83>>}

  """
  @spec encode(integer(), integer(), integer()) :: {:ok, bitstring()}
  def encode(year, month, day) do
    {:ok, date} = Date.new(year, month, day)
    encode(date)
  end

  @doc ~S"""

  `encode!/3` function encode year, month and day in MS-DOS Date
  Format.

  ## Examples

      iex> Dotzip.Date.encode!(2021,12,28)
      <<156, 83>>

  """
  @spec encode!(integer(), integer(), integer()) :: bitstring()
  def encode!(year, month, day) do
    {:ok, encoded} = encode(year, month, day)
    encoded
  end
end
