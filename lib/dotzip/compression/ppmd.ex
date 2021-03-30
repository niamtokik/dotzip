defmodule Dotzip.Compression.Ppmd do
  def compress(_data) do
    {:error, :not_supported}
  end

  def decompression(_data) do
    {:error, :not_supported}
  end
end
