defmodule Dotzip.Decode do

  def raw(data) do
    raw(data, [])
  end

  defp raw(<<>>, list) do
    {:ok, list}
  end

  defp raw(data, list) do
    pattern = { local_file_header?(data),
                central_directory_header?(data),
                end_central_directory?(data) }
    case pattern do
      {true,_,_} ->
        {:ok, result, rest} = Dotzip.LocalFileHeader.decode(data)
        raw(rest, [result|list])
      {_,true,_} ->
        {:ok, result, rest} = Dotzip.CentralDirectoryHeader.decode(data)
        raw(rest, [result|list])
      {_,_,true} ->
        {:ok, result, rest} = Dotzip.EndCentralDirectory.decode(data)
        raw(rest, [result|list])
      {_,_,_} ->
        {:ok, list}
    end
  end

  def file(file) do
    {:ok, data} = File.read(file)
    raw(data)
  end

  def encode(_data) do
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
