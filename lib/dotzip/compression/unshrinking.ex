defmodule Dotzip.Compression.Unshrinking do
  def compress(_data) do
    {:error, :not_supported}
  end

  def decompression(_data) do
    {:error, :not_supported}
  end
end
