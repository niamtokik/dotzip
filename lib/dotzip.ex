defmodule Dotzip do
  
  @moduledoc """

  Elixir Implementation of ZIP File Format.

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

  def encode(data) do
    {:error, :not_supported}
  end

  def encode_file(_file) do
    {:error, :not_supported}
  end

  def end_central_directory?(<<signature::binary-size(4), _::bitstring>>) do
    end_central_directory = Dotzip.EndCentralDirectory.signature()
    signature == end_central_directory
  end
  
  def central_directory_header?(<<signature::binary-size(4), _::bitstring>>) do
    central_directory_header = Dotzip.CentralDirectoryHeader.signature()
    signature == central_directory_header
  end
  
  def local_file_header?(<<signature::binary-size(4), _::bitstring>>) do
    local_file_header = Dotzip.LocalFileHeader.signature()
    signature == local_file_header
  end
  
end

