defmodule Dotzip.Time do

  @moduledoc """

  This module implement MS-DOS Time format. Here some source if you
  want Microsoft Time Format specification:

    - https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-dosdatetimetofiletime?redirectedfrom=MSDN
    - https://docs.microsoft.com/en-us/cpp/c-runtime-library/32-bit-windows-time-date-formats?view=msvc-170

  """

  @doc """

  `decode/1` function decode MS-DOS Time format. This function
  explicitely convert data from big-endian to little-endian.

  ## Examples

  This following example is from `a.zip` text file present in
  `test/fixtures/a.zip`.

      iex> Dotzip.Time.decode(<<0xd3, 0x53>>)
      {:ok, ~T[10:30:38.000000]}

  """
  @spec decode(bitstring()) :: {:ok, Time.t()}
  def decode(<<lsb::size(8), msb::size(8)>> = _bitstring) do
    decode2(<<msb, lsb>>)
  end


  @doc """

  `decode!/1` function decode MS-DOS Time format. This function
  explicitely convert data from big-endian to little-endian.

  ## Examples

  This following example is from `a.zip` text file present in
  `test/fixtures/a.zip`.

      iex> Dotzip.Time.decode!(<<0xd3, 0x53>>)
      ~T[10:30:38.000000]

  """
  @spec decode!(bitstring()) :: Time.t()
  def decode!(bitstring) do
    {:ok, time} = decode(bitstring)
    time
  end

  defp decode2(<<hour::size(5), minute::size(6), 30::size(5)>>) do
    Time.new(hour, minute, 59, 0)
  end
  defp decode2(<<hour::size(5), minute::size(6), second::size(5)>>) do
    Time.new(hour, minute, second*2, 0)
  end

  @doc """
  `encode/1` function encode time in little-endian format.

  ## Examples

      iex> Dotzip.Time.encode(~T[10:30:38.000000])
      {:ok, <<211, 83>>}

  """
  @spec encode(Time.t()) :: {:ok, bitstring()}
  def encode(time) do
    second = :erlang.round(time.second/2)
    minute = time.minute
    hour = time.hour
    <<lsb::size(8), msb::size(8)>> = <<hour::size(5), minute::size(6), second::size(5)>>
    {:ok, <<msb, lsb>>}
  end

  @doc """
  `encode!/1` function encode time in little-endian format.

  ## Examples

      iex> Dotzip.Time.encode!(~T[10:30:38.000000])
      <<211, 83>>

  """
  @spec encode!(Time.t()) :: bitstring()
  def encode!(time) do
    {:ok, encoded} = encode(time)
    encoded
  end

  @doc """
  `encode/3` function encode time in little-endian format.

  ## Examples

      iex> Dotzip.Time.encode(10,30,38)
      {:ok, <<211, 83>>}

  """
  @spec encode(integer(), integer(), integer()) :: {:ok, bitstring()}
  def encode(hour, minute, second) do
    case Time.new(hour, minute, second) do
      {:ok, time} -> encode(time)
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  `encode!/3` function encode time in little-endian format.

  ## Examples

      iex> Dotzip.Time.encode!(10,30,38)
      <<211, 83>>

  """
  @spec encode!(integer(), integer(), integer()) :: {:ok, bitstring()}
  def encode!(hour, minute, second) do
    {:ok, encoded} = encode(hour, minute, second)
    encoded
  end
end
