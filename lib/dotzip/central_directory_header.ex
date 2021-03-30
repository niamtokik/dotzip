defmodule Dotzip.CentralDirectoryHeader do

  defp signature() do
    << 0x50, 0x4b, 0x01, 0x02 >>
  end
  
  defp signature(<< 0x50, 0x4b, 0x01, 0x02, rest::bitstring >>) do
    {:ok, %{}, rest}
  end

  defp encode_signature(data) when is_map(data) do
    {:ok, data, signature()}
  end

  defp version_made({:ok, data, << version::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :version_made, version), rest}
  end

  defp encode_version_made({:ok, %{ :version_made => version_made } = data, buffer}) do
    {:ok, data, << buffer::bitstring, version_made::binary-size(2) >>}
  end
  
  defp version_needed({:ok, data, << version::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :version_needed, version), rest}
  end

  defp encode_version_needed({:ok, %{ :version_needed => version_needed } = data, buffer}) do
    {:ok, data, << buffer::bitstring, version_needed::binary-size(2) >>}
  end
  
  defp purpose_flag({:ok, data, << purpose_flag::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :purpose_flag, purpose_flag), rest}
  end

  defp encode_purpose_flag({:ok, %{ :purpose_flag => purpose_flag } = data, buffer}) do
    {:ok, data, << buffer::bitstring, purpose_flag::binary-size(2) >>}
  end

  defp compression_method({:ok, data, << compression_method::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :compression_method, compression_method), rest}
  end

  defp encode_compression_method({:ok, %{ :compression_method => compression_method } = data, buffer}) do
    {:ok, data, << buffer::bitstring, compression_method::binary-size(2) >>}
  end
  
  defp last_modification_time({:ok, data, << last_modification::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :last_modification_time, last_modification), rest}
  end

  defp last_modification_date({:ok, data, << last_modification_date::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :last_modification_date, last_modification_date), rest}
  end

  defp crc32({:ok, data, << crc32::binary-size(4), rest::bitstring >>}) do
   {:ok, Map.put(data, :crc32, crc32), rest} 
  end

  defp compressed_size({:ok, data, << compressed_size::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :compressed_size, compressed_size), rest}
  end

  defp uncompressed_size({:ok, data, << uncompressed_size::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :uncompressed_size, uncompressed_size), rest}
  end

  defp file_name_length({:ok, data, << file_name_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :file_name_length, file_name_length), rest }
  end

  defp extra_field_length({:ok, data, << extra_field_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :extra_field_length, extra_field_length), rest}
  end

  defp file_comment_length({:ok, data, << file_comment_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :file_comment_length, file_comment_length), rest}
  end

  defp disk_number_start({:ok, data, << disk_number_start::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :disk_number_start, disk_number_start), rest}
  end

  defp internal_file_attributes({:ok, data, << internal_file_attributes::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :internal_file_attributes, internal_file_attributes), rest}
  end

  defp external_file_attributes({:ok, data, << external_file_attributes::binary-size(4), rest::bitstring >>}) do
    {:ok, Map.put(data, :external_file_attributes, external_file_attributes), rest}
  end

  defp relative_offset({:ok, data, << relative_offset::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :relative_offset, relative_offset), rest}
  end

  defp file_name({:ok, data, rest}) do
    %{ :file_name_length => file_name_length } = data
    <<file_name::binary-size(file_name_length), r::bitstring>> = rest
    {:ok, Map.put(data, :file_name, file_name), r}
  end

  defp extra_field({:ok, data, rest}) do
    %{ :extra_field_length => extra_field_length } = data
    <<extra_field::binary-size(extra_field_length), r::bitstring>> = rest
    {:ok, Map.put(data, :extra_field, extra_field), r}
  end

  defp file_comment({:ok, data, rest}) do
    %{ :file_comment_length => file_comment_length } = data
    <<file_comment::binary-size(file_comment_length), r::bitstring>> = rest
    {:ok, Map.put(data, :file_comment, file_comment), r}
  end
  
  def decode(data) when is_bitstring(data) do
    {:ok, central_directory_header, rest} = signature(data)
    |> version_made()
    |> version_needed()
    |> purpose_flag()
    |> compression_method()
    |> last_modification_time()
    |> last_modification_date()
    |> crc32()
    |> compressed_size()
    |> uncompressed_size()
    |> file_name_length()
    |> extra_field_length()
    |> file_comment_length()
    |> disk_number_start()
    |> internal_file_attributes()
    |> external_file_attributes()
    |> relative_offset()
    |> file_name()
    |> extra_field()
    |> file_comment()
  end

  def encode(data) when is_map(data) do
    encode_signature(data)
    |> encode_version_made()
    |> encode_version_needed()
    |> encode_purpose_flag()
    |> encode_compression_method()
  end
  
end
