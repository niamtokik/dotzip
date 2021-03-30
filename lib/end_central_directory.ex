defmodule Dotzip.EndCentralDirectory do
  
  defp signature(<< 0x50, 0x4b, 0x05, 0x06, rest::bitstring >>) do
    {:ok, %{}, rest}
  end

  defp number_disk({:ok, data, << number_disk::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :number_disk, number_disk), rest}
  end

  defp number_disk_start({:ok, data, << number_disk::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :number_disk_start, number_disk), rest}
  end

  defp total_entries_disk({:ok, data, << total_entries_disk::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :total_entries_disk, total_entries_disk), rest}
  end
  
  defp total_entries({:ok, data, << total_entries::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :total_entries, total_entries), rest}
  end

  defp size({:ok, data, << size::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :size, size), rest}
  end

  defp offset({:ok, data, << offset::little-size(32), rest::bitstring >>}) do
    {:ok, Map.put(data, :offset, offset), rest}
  end

  defp comment_length({:ok, data, << comment_length::little-size(16), rest::bitstring >>}) do
    {:ok, Map.put(data, :comment_length, comment_length), rest}
  end

  defp comment({:ok, data, rest}) do
    %{ :comment_length => comment_length } = data
    << comment::binary-size(comment_length), r::bitstring >> = rest
    {:ok, Map.put(data, :comment, comment), r}
  end
  
  def decode(file) do
    {:ok, end_central_directory, rest} = signature(file)
    |> number_disk()
    |> number_disk_start()
    |> total_entries_disk()
    |> total_entries()
    |> size()
    |> offset()
    |> comment_length()
    |> comment()
  end
  
end
