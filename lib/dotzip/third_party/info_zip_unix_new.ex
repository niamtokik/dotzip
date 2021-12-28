defmodule Dotzip.ThirdParty.InfoZipUnixNew do

  @moduledoc """

  Info-ZIP New Unix Extra Field Third Party Naive Implementation. This
  code is currently not safe.

  """

  @spec tag() :: bitstring()
  def tag(), do: <<0x78, 0x75>>

  @spec decode(bitstring()) :: {:ok, map(), bitstring()}
  def decode(data), do: decode(data, [])

  @doc """

  This code is currently not safe.

  ## Examples

      iex> Dotzip.ThirdParty.InfoZipUnixNew.decode(<<117, 120, 11, 0, 1, 4, 232, 3, 0, 0, 4, 232, 3, 0, 0>>)
      {:ok, %{gid: 1000, gid_size: 32, tsize: 11, uid: 1000, uid_size: 32, version: 1}, ""}

  """
  @spec decode(bitstring(), Keyword.t()) :: {:ok, map(), bitstring()}
  def decode(data, opts) do
    {struct, rest} = data
    |> decode_tag(opts)
    |> decode_tsize(opts)
    |> decode_version(opts)
    |> decode_uid_size(opts)
    |> decode_uid(opts)
    |> decode_gid_size(opts)
    |> decode_gid(opts)
    {:ok, struct, rest}
  end

  defp decode_tag(<<0x75, 0x78, rest :: bitstring>>, _opts), do: {%{}, rest}

  defp decode_tsize({ struct, <<tsize :: little-size(16), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :tsize, tsize), rest}
  end

  defp decode_version({ struct, <<version :: little-size(8), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :version, version), rest}
  end

  defp decode_uid_size({ struct, <<uid_size :: little-size(8), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :uid_size, uid_size*8), rest}
  end

  defp decode_uid({ %{ uid_size: uid_size } = struct, data}, _opts) do
    << uid :: little-size(uid_size), rest :: bitstring >> = data
    {Map.put(struct, :uid, uid), rest}
  end

  defp decode_gid_size({ struct, <<gid_size :: little-size(8), rest :: bitstring>>}, _opts) do
    {Map.put(struct, :gid_size, gid_size*8), rest}
  end

  defp decode_gid({ %{ gid_size: gid_size } = struct, data}, _opts) do
    << gid :: little-size(gid_size), rest :: bitstring >> = data
    {Map.put(struct, :gid, gid), rest}
  end
end
