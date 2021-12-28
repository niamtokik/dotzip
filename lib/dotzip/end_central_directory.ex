defmodule Dotzip.EndCentralDirectory do

  def signature() do
    << 0x50, 0x4b, 0x05, 0x06 >>
  end
  
  defp signature(<< 0x50, 0x4b, 0x05, 0x06, rest::bitstring >>) do
    {:ok, %{}, rest}
  end

  defp encode_signature(data) when is_map(data) do
    {:ok, data, signature()}
  end

  defp number_disk({:ok, data, << number_disk::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :number_disk, number_disk), rest}
  end

  defp encode_number_disk({:ok, %{ :number_disk => number_disk } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, number_disk::little-size(16)>>}
  end

  defp number_disk_start({:ok, data, << number_disk::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :number_disk_start, number_disk), rest}
  end

  defp encode_number_disk_start({:ok, %{ :number_disk_start => number_disk_start } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, number_disk_start::little-size(16)>> }
  end

  defp total_entries_disk({:ok, data, << total_entries_disk::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :total_entries_disk, total_entries_disk), rest}
  end

  defp encode_total_entries_disk({:ok, %{ :total_entries_disk => total_entries_disk } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, total_entries_disk::little-size(16)>> }
  end
  
  defp total_entries({:ok, data, << total_entries::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :total_entries, total_entries), rest}
  end

  defp encode_total_entries({:ok, %{ :total_entries => total_entries } = data, buffer }) do
    {:ok, data, <<buffer::bitstring, total_entries::little-size(16)>> }
  end

  defp size({:ok, data, << size::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :size, size), rest}
  end

  defp encode_size({:ok, %{ :size => size } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, size::little-size(32)>>}
  end

  defp offset({:ok, data, << offset::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :offset, offset), rest}
  end

  defp encode_offset({:ok, %{ :offset => offset } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, offset::little-size(32)>> }
  end

  defp comment_length({:ok, data, << comment_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :comment_length, comment_length), rest}
  end

  defp encode_comment_length({:ok, %{ :comment_length => comment_length } = data, buffer}) do
    {:ok, data, <<buffer::bitstring, comment_length::little-size(16)>> }
  end
  
  defp comment({:ok, data, rest}) do
    %{ :comment_length => comment_length } = data
    << comment::binary-size(comment_length), r::bitstring >> = rest
    {:ok, Map.put(data, :comment, comment), r}
  end

  defp encode_comment({:ok, %{ :comment => comment, :comment_length => comment_length} = data, buffer}) do
    {:ok, data, <<buffer::bitstring, comment::binary-size(comment_length)>>}
  end
  
  def decode(file) do
     signature(file)
    |> number_disk()
    |> number_disk_start()
    |> total_entries_disk()
    |> total_entries()
    |> size()
    |> offset()
    |> comment_length()
    |> comment()
  end

  def encode(data) do
    encode_signature(data)
    |> encode_number_disk()
    |> encode_number_disk_start()
    |> encode_total_entries_disk()
    |> encode_total_entries()
    |> encode_size()
    |> encode_offset()
    |> encode_comment_length()
    |> encode_comment()
  end
  
end
