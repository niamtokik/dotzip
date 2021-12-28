defmodule Dotzip.ExtraField.Unix do

  @moduledoc """
  
        The following is the layout of the UNIX "extra" block.
        Note: all fields are stored in Intel low-byte/high-byte 
        order.

        Value       Size          Description
        -----       ----          -----------
        0x000d      2 bytes       Tag for this "extra" block type
        TSize       2 bytes       Size for the following data block
        Atime       4 bytes       File last access time
        Mtime       4 bytes       File last modification time
        Uid         2 bytes       File user ID
        Gid         2 bytes       File group ID
        (var)       variable      Variable length data field

        The variable length data field will contain file type 
        specific data.  Currently the only values allowed are
        the original "linked to" file names for hard or symbolic 
        links, and the major and minor device node numbers for
        character and block device nodes.  Since device nodes
        cannot be either symbolic or hard links, only one set of
        variable length data is stored.  Link files will have the
        name of the original file stored.  This name is NOT NULL
        terminated.  Its size can be determined by checking TSize -
        12.  Device entries will have eight bytes stored as two 4
        byte entries (in little endian format).  The first entry
        will be the major device number, and the second the minor
        device number.

  """

  defstruct [
    atime: 0,
    mtime: 0,
    uid: 0,
    gid: 0,
    var: 0
    ]

  @spec tag() :: bitstring()
  def tag(), do: <<0x00, 0x0d>>
  
  @spec is?(bitstring()) :: boolean()
  def is?(<<tag::bitstring-size(16), _rest::bitstring>>), do: tag == tag()

  @spec decode(bitstring(), Keyword.t()) :: {:ok, map()}
  def decode(bitstring, opts) do
    {%{}, bitstring}
    |> decode_tag(opts)
    |> decode_gid(opts)
    |> decode_uid(opts)
    |> decode_mtime(opts)
    |> decode_atime(opts)
    |> decode_tsize(opts)
  end

  defp decode_tag({struct, <<0x00, 0x0d, rest ::bitstring>>}, _opts) do
    {struct, rest}
  end

  defp decode_tsize({struct, <<tsize :: little-size(16), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :tsize, tsize), rest}
  end

  defp decode_atime({struct, <<atime :: bitstring-little-size(32), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :atime, atime), rest}
  end

  defp decode_mtime({struct, <<mtime :: bitstring-little-size(32), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :mtime, mtime), rest}
  end

  defp decode_uid({struct, <<uid :: bitstring-little-size(16), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :uid, uid), rest}
  end

  defp decode_gid({struct, <<gid :: bitstring-little-size(16), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :gid, gid), rest}
  end

  defp decode_variable_data_field({%{ tsize: tsize } = struct, data}, _opts) do
    << var :: binary-little-size(tsize), rest :: bitstring >> = data
    {Map.put(struct, :variable_data_field, var), rest}
  end

  defp encode_tag({data, buffer}) do
    tag = tag()
    {:ok, data, <<tag::binary-size(2), buffer::bitstring>>}
  end

  defp encode_tsize({:ok, data, buffer}) do
    s = byte_size(buffer)
    {:ok, data, <<s::size(16), buffer::bitstring>>}
  end

  defp encode_atime({:ok, %{ :atime => atime } = data, buffer}) do
    {:ok, data, <<atime::size(32), buffer::bitstring>>}
  end

  defp encode_mtime({:ok, %{ :mtime => mtime } = data, buffer}) do
    {:ok, data, <<mtime::size(32), buffer::bitstring>>}
  end

  defp encode_uid({:ok, %{ :uid => uid } = data, buffer}) do
    {:ok, data, <<uid::size(16), buffer::bitstring>>}
  end

  defp encode_gid({:ok, %{ :gid => gid } = data, buffer}) do
    {:ok, data, <<gid::size(16), buffer::bitstring>>}
  end

  defp encode_var(data) do
    {:ok, data, <<>>}
  end

  @doc """

  Encode an Unix Extra field.

  """
  def encode(data) do
    encode_var(data)
    |> encode_gid()
    |> encode_uid()
    |> encode_mtime()
    |> encode_atime()
    |> encode_tsize()
    |> encode_tag()
  end

  defp decode_tag(<<0x00, 0x0d, rest::bitstring>>) do
    {:ok, %{}, rest}
  end

  defp decode_tsize({:ok, data, <<tsize::size(16), rest::bitstring>>}) do
    {:ok, Map.put(data, :tsize, tsize), rest}
  end

  defp decode_atime({:ok, data, <<atime::size(32), rest::bitstring>>}) do
    {:ok, Map.put(data, :atime, atime), rest}
  end

  defp decode_mtime({:ok, data, <<mtime::size(32), rest::bitstring>>}) do
    {:ok, Map.put(data, :mtime, mtime), rest}
  end

  defp decode_uid({:ok, data, <<uid::size(16), rest::bitstring>>}) do
    {:ok, Map.put(data, :uid, uid), rest}
  end

  defp decode_gid({:ok, data, <<gid::size(16), rest::bitstring>>}) do
    {:ok, Map.put(data, :gid, gid ), rest}
  end

  defp decode_var({:ok, data, rest}) do
    {:ok, data, rest}
  end

  @doc """

  Decode an Unix Extra field.

  """
  
  def decode(bitstring) do
    decode_tag(bitstring)
    |> decode_tsize()
    |> decode_atime()
    |> decode_mtime()
    |> decode_uid()
    |> decode_gid()
    |> decode_var()
  end

end
