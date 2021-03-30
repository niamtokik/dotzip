defmodule Dotzip.LocalFileHeader do
  
  defp signature(<< 0x50, 0x4b, 0x03, 0x04, rest::bitstring >>) do
    {:ok, %{}, rest}
  end

  defp version({:ok, data, << version::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :version, version), rest}
  end

  defp purpose_flag({:ok, data, << purpose_flag::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :purpose_flag, purpose_flag), rest}
  end

  defp compression_method({:ok, data, << compression_method::binary-size(2), rest::bitstring >>}) do
    {:ok, Map.put(data, :compression_method, compression_method), rest}
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

  defp content({:ok, data, rest}) do
    %{ :compressed_size => compressed_size } = data
    <<content::binary-size(compressed_size), r::bitstring>> = rest
    {:ok, Map.put(data, :content, content), r}
  end
  
  def decode(file) do
    {:ok, local_file_header, rest} = signature(file)
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
  
end
