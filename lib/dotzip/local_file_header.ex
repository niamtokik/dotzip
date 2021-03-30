defmodule Dotzip.LocalFileHeader do

  def signature() do
    << 0x50, 0x4b, 0x03, 0x04 >>
  end
  
  defp signature(<< 0x50, 0x4b, 0x03, 0x04, rest::bitstring >>) do
    {:ok, %{}, rest}
  end

  defp encode_signature(data) when is_map(data) do
    {:ok, data, signature()}
  end

  defp version({:ok, data, << version::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :version, version), rest}
  end

  defp encode_version({:ok, %{ :version => version } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, version::binary-size(2)>>}
  end

  defp purpose_flag({:ok, data, << purpose_flag::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :purpose_flag, purpose_flag), rest}
  end
  
  defp encode_purpose_flag({:ok, %{ :purpose_flag => purpose_flag } = data, buffer }) do
    {:ok, data, <<buffer::bitstring, purpose_flag::binary-size(2)>> }
  end

  defp compression_method_type(data) do
    case data do
      0 -> :stored
      1 -> :shrunk
      2 -> :reduced_factor1
      3 -> :reduced_factor2
      4 -> :reduced_factor3
      5 -> :reduced_factor4
      6 -> :imploded
      7 -> :tokenizing
      8 -> :deflated
      9 -> :deflate64
      10 -> :pkware
      11 -> :reserved
      12 -> :bzip2
      13 -> :reserved
      14 -> :lzma
      15 -> :reserved
      16 -> :reserved
      17 -> :reserved
      18 -> :terse
      19 -> :lz77
      97 -> :wavpack
      98 -> :ppmd
    end
  end
  
  defp compression_method({:ok, data, << compression_method::little-size(16), rest::bitstring >>}) do
    method = compression_method_type(compression_method)
    {:ok, Map.put(data, :compression_method, method), rest}
  end

  defp encode_compression_method({:ok, %{ :compression_method => compression_method } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, compression_method::binary-size(2)>> }
  end

  defp last_modification_time({:ok, data, << last_modification_time::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :last_modification_time, last_modification_time), rest}
  end

  defp encode_last_modification_time({:ok, %{ :last_modification_time => last_modification_time } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, last_modification_time::little-size(16)>>}
  end

  defp last_modification_date({:ok, data, << last_modification_date::little-binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :last_modification_date, last_modification_date), rest}
  end

  defp encode_last_modification_date({:ok, %{ :last_modification_date => last_modification_date } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, last_modification_date::little-size(16)>>}
  end

  defp crc32({:ok, data, << crc32::binary-size(4), rest::bitstring >>}) do
   {:ok, Map.put(data, :crc32, crc32), rest} 
  end

  defp encode_crc32({:ok, %{ :crc32 => crc32 } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, crc32::binary-size(4)>> }
  end

  defp compressed_size({:ok, data, << compressed_size::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :compressed_size, compressed_size), rest}
  end

  defp encode_compressed_size({:ok, %{ :compressed_size => compressed_size } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, compressed_size::little-size(32)>>}
  end
  
  defp uncompressed_size({:ok, data, << uncompressed_size::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :uncompressed_size, uncompressed_size), rest}
  end

  defp encode_uncompressed_size({:ok, %{ :uncompressed_size => uncompressed_size } = data, buffer }) do
    {:ok, data, <<buffer::bitstring, uncompressed_size::little-size(32)>>}
  end

  defp file_name_length({:ok, data, << file_name_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :file_name_length, file_name_length), rest }
  end

  defp encode_file_name_length({:ok, %{ :file_name_length => file_name_length } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, file_name_length::little-size(16)>> }
  end
  
  defp extra_field_length({:ok, data, << extra_field_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :extra_field_length, extra_field_length), rest}
  end

  defp encode_extra_field_length({:ok, %{ :extra_field_length => extra_field_length } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, extra_field_length::little-size(16)>>}
  end

  defp file_name({:ok, data, rest}) do
    %{ :file_name_length => file_name_length } = data
    <<file_name::binary-size(file_name_length), r::bitstring>> = rest
    {:ok, Map.put(data, :file_name, file_name), r}
  end

  defp encode_file_name({:ok, %{ :file_name => file_name, :file_name_length => file_name_length } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, file_name::binary-size(file_name_length)>>}
  end

  defp extra_field({:ok, data, rest}) do
    %{ :extra_field_length => extra_field_length } = data
    <<extra_field::binary-size(extra_field_length), r::bitstring>> = rest
    {:ok, Map.put(data, :extra_field, extra_field), r}
  end

  defp encode_extra_field({:ok, %{ :extra_field => extra_field, :extra_field_length => extra_field_length } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, extra_field::binary-size(extra_field_length)>>}
  end

  defp content({:ok, data, rest}) do
    %{ :compressed_size => compressed_size } = data
    <<content::binary-size(compressed_size), r::bitstring>> = rest
    {:ok, Map.put(data, :content, content), r}
  end

  defp encode_content({:ok, %{ :compressed_size => compressed_size, :content => content } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, content::binary-size(compressed_size)>>}
  end
  
  def decode(data) do
    signature(data)
    |> version()
    |> purpose_flag()
    |> compression_method()
    |> last_modification_time()
    |> last_modification_date()
    |> crc32()
    |> compressed_size()
    |> uncompressed_size()
    |> file_name_length()
    |> extra_field_length()
    |> file_name()
    |> extra_field()
    |> content()
  end

  def encode(data) do
    encode_signature(data)
    |> encode_version()
    |> encode_purpose_flag()
    |> encode_compression_method()
    |> encode_last_modification_time()
    |> encode_last_modification_date()
    |> encode_crc32()
    |> encode_compressed_size()
    |> encode_uncompressed_size()
    |> encode_file_name_length()
    |> encode_extra_field_length()
    |> encode_file_name()
    |> encode_extra_field()
    |> encode_content()
    end  
end
