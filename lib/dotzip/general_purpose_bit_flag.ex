defmodule Dotzip.GeneralPurposeBitFlag do

  defstruct [
    encrypted: false,
    compression_bits: [0, 0],
    data_descriptor_crc: false,
    enhanced_deflating: false,
    compressed_patched_data: false,
    strong_encryption: false,
    efs: false,
    enhanced_compression: false,
    masked_encryption: false
  ]

  @spec decode(bitstring()) :: {:ok, map(), bitstring()}
  def decode(<<flags :: binary-size(16), rest :: bitstring>>) do
    {struct, _r} = {%Dotzip.GeneralPurposeBitFlag{}, flags}
    |> decode_encrypted()
    |> decode_compression_bits()
    |> decode_data_descriptor_crc32()
    |> decode_enhanced_deflating()
    |> decode_compressed_patched_data()
    |> decode_strong_encryption()
    |> decode_unused()
    |> decode_unused()
    |> decode_unused()
    |> decode_unused()
    |> decode_efs()
    |> decode_enhanced_compression()
    |> decode_masked_encryption()
    |> decode_reserved()
    |> decode_reserved()
    {:ok, struct, rest}
  end

  defp decode_encrypted({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :encrypted, :false), rest}
  end
  defp decode_encrypted({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :encrypted, :true), rest}
  end

  defp decode_compression_bits({struct, <<bit1::size(1), bit2::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :compression_bits, {bit1, bit2}), rest}
  end

  defp decode_data_descriptor_crc32({struct, <<flag::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :data_descriptor_crc, flag), rest}
  end

  defp decode_enhanced_deflating({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :enhanced_deflating, false), rest}
  end
  defp decode_enhanced_deflating({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :enhanced_deflating, true), rest}
  end

  defp decode_compressed_patched_data({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :compressed_patched_data, false), rest}
  end
  defp decode_compressed_patched_data({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :compressed_patched_data, true), rest}
  end

  defp decode_strong_encryption({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :strong_encryption, false), rest}
  end
  defp decode_strong_encryption({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :strong_encryption, true), rest}
  end

  defp decode_unused({struct, <<_::size(1), rest :: bitstring>>}) do
    {struct, rest}
  end

  defp decode_efs({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :efs, false), rest}
  end
  defp decode_efs({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :efs, true), rest}
  end

  defp decode_enhanced_compression({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :enhanced_compression, false), rest}
  end
  defp decode_enhanced_compression({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :enhanced_compression, true), rest}
  end

  defp decode_masked_encryption({struct, <<0::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :masked_encryption, false), rest}
  end
  defp decode_masked_encryption({struct, <<1::size(1), rest :: bitstring>>}) do
    {Map.put(struct, :masked_encryption, true), rest}
  end

  defp decode_reserved({struct, <<_::size(1), rest :: bitstring>>}) do
    {struct, rest}
  end

  def encode() do
  end
end
