defmodule Dotzip.VersionMadeBy do

  @spec decode(bitstring()) :: {:ok, atom(), bitstring}
  def decode(<<00::size(16), rest>>), do: {:ok, :msdos, rest}
  def decode(<<01::size(16), rest>>), do: {:ok, :amiga, rest}
  def decode(<<02::size(16), rest>>), do: {:ok, :openvms, rest}
  def decode(<<03::size(16), rest>>), do: {:ok, :unix, rest}
  def decode(<<04::size(16), rest>>), do: {:ok, :vmcms, rest}
  def decode(<<05::size(16), rest>>), do: {:ok, :atarist, rest}
  def decode(<<06::size(16), rest>>), do: {:ok, :os2, rest}
  def decode(<<07::size(16), rest>>), do: {:ok, :macintosh, rest}
  def decode(<<08::size(16), rest>>), do: {:ok, :zsystem, rest}
  def decode(<<09::size(16), rest>>), do: {:ok, :cpm, rest}
  def decode(<<10::size(16), rest>>), do: {:ok, :ntfs, rest}
  def decode(<<11::size(16), rest>>), do: {:ok, :mvs, rest}
  def decode(<<12::size(16), rest>>), do: {:ok, :vse, rest}
  def decode(<<13::size(16), rest>>), do: {:ok, :acorn, rest}
  def decode(<<14::size(16), rest>>), do: {:ok, :vfat, rest}
  def decode(<<15::size(16), rest>>), do: {:ok, :alternatemvs, rest}
  def decode(<<16::size(16), rest>>), do: {:ok, :beos, rest}
  def decode(<<17::size(16), rest>>), do: {:ok, :tandem, rest}
  def decode(<<18::size(16), rest>>), do: {:ok, :os400, rest}
  def decode(<<19::size(16), rest>>), do: {:ok, :osx, rest}
  def decode(<<_::size(16), rest>>),  do: {:ok, :unused, rest}
  def decode(integer) when is_integer(integer), do: decode(<<integer::size(16)>>)

  @spec encode(atom()) :: {:ok, bitstring()} | {:error, any()}
  def encode(:msdos), do: {:ok, <<0::size(16)>>}
  def encode(:amiga), do: {:ok, <<1::size(16)>>}
  def encode(:openvms), do: {:ok, <<2::size(16)>>}
  def encode(:unix), do: {:ok, <<3::size(16)>>}
  def encode(_), do: {:error, :unsupported}

  @spec encode(atom(), bitstring()) :: bitstring()
  def encode(version, data) do
    case encode(version) do
      {:ok, encoded} -> {:ok, <<encoded::size(16), data>>}
      {:error, error} -> {:error, error}
    end
  end

end
