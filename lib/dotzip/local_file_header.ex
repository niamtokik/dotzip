defmodule Dotzip.LocalFileHeader do

  @moduledoc """
  `Dotzip.LocalFileHeader` module is a low level module used to decode
  and encode Local File Header data-structure. This module should not
  be used by developers as it, and can be changed at anytime. Only
  stable interfaces are `decode/1`, `decode/2`, `encode/1` and
  `encode/2` functions. Generated data structure may change during
  development phase.
  """

  @doc """
  See `decode/2` function.
  """
  @spec decode(bitstring()) :: {:ok, map(), bitstring()}
  def decode(data) do
    decode(data, [])
  end

  @doc """
  `decode/2` function decode a binary zip payload and convert it in
  `map()` data structure. Options passed as second argument can alter
  the behavior of this function.
  """
  @spec decode(bitstring(), Keyword.t()) :: {:ok, map(), bitstring()}
  def decode(data, opts) do
    {struct, rest} = data
    |> decode_signature(opts)
    |> decode_version(opts)
    |> decode_purpose_flag(opts)
    |> decode_compression_method(opts)
    |> decode_last_modification_time(opts)
    |> decode_last_modification_date(opts)
    |> decode_crc32(opts)
    |> decode_compressed_size(opts)
    |> decode_uncompressed_size(opts)
    |> decode_file_name_length(opts)
    |> decode_extra_field_length(opts)
    |> decode_file_name(opts)
    |> decode_extra_field(opts)
    |> decode_content(opts)
    {:ok, struct, rest}
  end

  @doc """
  `signature/0` returns the local file header binary signature.
  """
  @spec signature() :: bitstring()
  def signature(), do: << 0x50, 0x4b, 0x03, 0x04 >>

  defp decode_signature(<< 0x50, 0x4b, 0x03, 0x04, rest::bitstring >>, _opts) do
    {%{}, rest}
  end

  defp decode_version({data, << version::binary-little-size(2), rest::bitstring >>}, _opts) do
    {Map.put(data, :version, version), rest}
  end

  defp decode_purpose_flag({data, << purpose_flag::binary-little-size(2), rest::bitstring >>}, _opts) do
    {Map.put(data, :purpose_flag, purpose_flag), rest}
  end

  @spec compression_method_type(integer() | atom()) :: atom() | integer()
  defp compression_method_type(0), do: :stored
  defp compression_method_type(:stored), do: 0

  defp compression_method_type(1), do: :shrunk
  defp compression_method_type(:shrunk), do: 1

  defp compression_method_type(2), do: :reduced_factor1
  defp compression_method_type(:reduced_factor1), do: 2

  defp compression_method_type(3), do: :reduced_factor2
  defp compression_method_type(:reduced_factor2), do: 3

  defp compression_method_type(4), do: :reduced_factor3
  defp compression_method_type(:reduced_factor3), do: 4

  defp compression_method_type(5), do: :reduced_factor4
  defp compression_method_type(:reduced_factor4), do: 5

  defp compression_method_type(6), do: :imploded
  defp compression_method_type(:imploded), do: 6

  defp compression_method_type(7), do: :tokenizing
  defp compression_method_type(:tokenizing), do: 7

  defp compression_method_type(8), do: :deflated
  defp compression_method_type(:deflated), do: 8

  defp compression_method_type(9), do: :deflated64
  defp compression_method_type(:deflated64), do: 9

  defp compression_method_type(10), do: :pkware
  defp compression_method_type(:pkware), do: 10

  defp compression_method_type(11), do: :reserved
  defp compression_method_type(:reserved), do: 11

  defp compression_method_type(12), do: :bzip2
  defp compression_method_type(:bzip2), do: 12

  defp compression_method_type(13), do: :reserved
  defp compression_method_type(:reserved), do: 13

  defp compression_method_type(14), do: :lzma
  defp compression_method_type(:lzma), do: 14

  defp compression_method_type(15), do: :reserved
  defp compression_method_type(:reserved), do: 15

  defp compression_method_type(16), do: :reserved
  defp compression_method_type(:reserved), do: 16

  defp compression_method_type(17), do: :reserved
  defp compression_method_type(:reserved), do: 17

  defp compression_method_type(18), do: :terse
  defp compression_method_type(:terse), do: 18

  defp compression_method_type(19), do: :lz77
  defp compression_method_type(:lz77), do: 19

  defp compression_method_type(97), do: :wavpack
  defp compression_method_type(:wavpack), do: 97

  defp compression_method_type(98), do: :ppmd
  defp compression_method_type(:ppmd), do: 98

  defp decode_compression_method({data, << compression_method::little-size(16), rest::bitstring >>}, _opts) do
    method = compression_method_type(compression_method)
    {Map.put(data, :compression_method, method), rest}
  end

  defp decode_last_modification_time({data, << last_modification_time::binary-little-size(2), rest::bitstring >>}, _opts) do
    {:ok, decoded} = Dotzip.Time.decode(last_modification_time)
    {Map.put(data, :last_modification_time, decoded), rest}
  end

  defp decode_last_modification_date({data, << last_modification_date::binary-little-size(2), rest::bitstring >>}, _opts) do
    last_modification_date |> IO.inspect()
    {:ok, decoded} = Dotzip.Date.decode(last_modification_date)
    {Map.put(data, :last_modification_date, decoded), rest}
  end

  defp decode_crc32({data, << crc32::binary-size(4), rest::bitstring >>}, _opts) do
    {Map.put(data, :crc32, crc32), rest}
  end

  defp decode_extra_field_length({data, << extra_field_length::little-size(16), rest::bitstring >>}, _opts) do
    {Map.put(data, :extra_field_length, extra_field_length), rest}
  end

  defp decode_compressed_size({data, << compressed_size::little-size(32), rest::bitstring >>}, _opts) do
    {Map.put(data, :compressed_size, compressed_size), rest}
  end

  defp decode_uncompressed_size({data, << uncompressed_size::little-size(32), rest::bitstring >>}, _opts) do
    {Map.put(data, :uncompressed_size, uncompressed_size), rest}
  end

  defp decode_file_name_length({data, << file_name_length::little-size(16), rest::bitstring >>}, _opts) do
    {Map.put(data, :file_name_length, file_name_length), rest }
  end

  defp decode_file_name({data, rest}, _opts) do
    %{ :file_name_length => file_name_length } = data
    <<file_name::binary-size(file_name_length), r::bitstring>> = rest
    {Map.put(data, :file_name, file_name), r}
  end

  defp decode_extra_field({data, rest}, _opts) do
    %{ :extra_field_length => extra_field_length } = data
    <<extra_field::binary-size(extra_field_length), r::bitstring>> = rest
    {Map.put(data, :extra_field, extra_field), r}
  end

  defp decode_content({data, rest}, opts) do
    preload = Keyword.get(opts, :preload, :false)
    case preload do
      false ->
        %{ compressed_size: compressed_size } = data
        <<content::binary-size(compressed_size), r::bitstring>> = rest
        {Map.put(data, :content, content), r}
      true ->
        %{ compressed_size: compressed_size } = data
        <<_::binary-size(compressed_size), r::bitstring>> = rest
        {Map.put(data, :content, {:ref, :wip}), r}
    end
  end


  @doc """
  See `encode/2` function.
  """
  @spec encode(map()) :: {:ok, bitstring()}
  def encode(struct) do
    encode(struct, [])
  end

  @doc """
  `encode/2` function takes a `map()` structure and encode it in
  `bitstring()`. Options can alter the behaviour of the encoding.
  """
  @spec encode(map(), Keyword.t()) :: bitstring()
  def encode(struct, opts) do
    ret = encode_signature(struct, opts)
    |> encode_version(opts)
    |> encode_purpose_flag(opts)
    |> encode_compression_method(opts)
    |> encode_last_modification_time(opts)
    |> encode_last_modification_date(opts)
    |> encode_crc32(opts)
    |> encode_compressed_size(opts)
    |> encode_uncompressed_size(opts)
    |> encode_file_name_length(opts)
    |> encode_extra_field_length(opts)
    |> encode_file_name(opts)
    |> encode_extra_field(opts)
    |> encode_content(opts)
    {:ok, ret}
  end

  defp encode_signature(data, _opts) when is_map(data) do
    {data, signature()}
  end

  defp encode_version({%{ :version => version } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, version::binary-size(2)>>}
  end

  defp encode_purpose_flag({%{ :purpose_flag => purpose_flag } = data, buffer }, _opts) do
    {data, <<buffer::bitstring, purpose_flag::binary-size(2)>> }
  end

  defp encode_compression_method({%{ :compression_method => compression_method } = data, buffer}, _opts) do
    type = compression_method_type(compression_method)
    {data, <<buffer::bitstring, type::little-size(16)>> }
  end

  defp encode_last_modification_time({ %{ :last_modification_time => last_modification_time } = data, buffer}, _opts) do
    {:ok, encoded} = Dotzip.Time.encode(last_modification_time)
    {data, <<buffer::bitstring, encoded::bitstring-size(16)>>}
  end

  defp encode_last_modification_date({ %{ :last_modification_date => last_modification_date } = data, buffer}, _opts) do
    {:ok, encoded} = Dotzip.Date.encode(last_modification_date)
    {data, <<buffer::bitstring, encoded::bitstring-size(16)>>}
  end

  defp encode_crc32({ %{ :crc32 => crc32 } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, crc32::binary-size(4)>> }
  end

  defp encode_compressed_size({ %{ :compressed_size => compressed_size } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, compressed_size::little-size(32)>>}
  end

  defp encode_uncompressed_size({ %{ :uncompressed_size => uncompressed_size } = data, buffer }, _opts) do
    {data, <<buffer::bitstring, uncompressed_size::little-size(32)>>}
  end

  defp encode_file_name_length({ %{ :file_name_length => file_name_length } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, file_name_length::little-size(16)>> }
  end

  defp encode_extra_field_length({ %{ :extra_field_length => extra_field_length } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, extra_field_length::little-size(16)>>}
  end

  defp encode_file_name({ %{ :file_name => file_name, :file_name_length => file_name_length } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, file_name::binary-size(file_name_length)>>}
  end

  defp encode_extra_field({%{ :extra_field => extra_field, :extra_field_length => extra_field_length } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, extra_field::binary-size(extra_field_length)>>}
  end

  defp encode_content({%{ :compressed_size => compressed_size, :content => content } = data, buffer}, _opts) do
    {data, <<buffer::bitstring, content::binary-size(compressed_size)>>}
  end
end
