defmodule Dotzip.ExtraField.Zip64ExtendedInformation do

  @spec tag() :: bitstring()
  def tag(), do: <<0x01, 0x00>>

  @spec decode(bitstring()) :: {:ok, map(), bitstring()}
  def decode(data), do: decode(data, [])

  @spec decode(bitstring(), Keyword.t()) :: {:ok, map(), bitstring()}
  def decode(data, opts) do
    {struct, rest} = data
    |> decode_tag(opts)
    |> decode_size(opts)
    |> decode_original_size(opts)
    |> decode_compressed_size(opts)
    |> decode_relative_header_offset(opts)
    |> decode_disk_start_number(opts)
    {:ok, struct, rest}
  end

  defp decode_tag(<<0x01, 0x00, rest :: bitstring>>, _opts) do
    {%{}, rest}
  end

  defp decode_size({struct, <<size :: little-size(16), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :size, size), rest}
  end

  defp decode_original_size({struct, <<original_size :: little-size(64), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :original_size, original_size), rest}
  end

  defp decode_compressed_size({struct, <<compressed_size :: little-size(64), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :compressed_size, compressed_size), rest}
  end

  defp decode_relative_header_offset({struct, <<offset :: little-size(64), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :relative_header_offset, offset), rest}
  end

  defp decode_disk_start_number({struct, <<disk :: little-size(32), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :disk_start_number, disk), rest}
  end

end
