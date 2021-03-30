defmodule Dotzip.Compression.EnhancedDeflating do
  def compress(_data) do
    {:error, :not_supported}
  end

  def decompression(_data) do
    {:error, :not_supported}
  end
end
