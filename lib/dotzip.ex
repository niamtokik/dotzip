defmodule Dotzip do
  
  @moduledoc """
  Elixir Implementation of ZIP File Format. https://pkware.cachefly.net/webdocs/APPNOTE/APPNOTE-6.3.3.TXT
  """

  def decode(data) do
    {:ok, local, rest} = Dotzip.LocalFileHeader.decode(data)
    {:ok, central, r} = Dotzip.CentralDirectoryHeader.decode(rest)
    {:ok, e, rr} = Dotzip.EndCentralDirectory.decode(r)
    {local, central, e, rr}
  end

  def decode_file(file) do
    {:ok, data} = :file.read_file(file)
    decode(data)
  end


  def encode(_data) do
    {:error, :not_supported}
  end

  def encode_file(_file) do
    {:error, :not_supported}
  end
  
end

