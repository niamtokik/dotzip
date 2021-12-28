defmodule Dotzip.Crc32 do
  def raw(bitstring) do
    raw(bitstring, [])
  end
  def raw(bitstring, _opts) do
    checksum = :erlang.crc32(bitstring)
    {:ok, <<checksum::size(16)>>}
  end

  def file(path) do
    file(path, [])
  end
  def file(path, opts) do
    {:ok, content} = File.read(path)
    raw(content, opts)
  end
end
