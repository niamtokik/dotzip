defmodule Dotzip.VersionNeededTo do

  @spec decode(bitstring()) :: {:ok, bitstring(), bitstring()}
  def decode(<<10::size(16), rest>>), do: {:ok, "1.0", rest}
  def decode(<<11::size(16), rest>>), do: {:ok, "1.1", rest}
  def decode(<<20::size(16), rest>>), do: {:ok, "2.0", rest}
  def decode(<<21::size(16), rest>>), do: {:ok, "2.1", rest}
  def decode(<<25::size(16), rest>>), do: {:ok, "2.5", rest}
  def decode(<<27::size(16), rest>>), do: {:ok, "2.7", rest}
  def decode(<<45::size(16), rest>>), do: {:ok, "4.5", rest}
  def decode(<<46::size(16), rest>>), do: {:ok, "4.6", rest}
  def decode(<<50::size(16), rest>>), do: {:ok, "5.0", rest}
  def decode(<<51::size(16), rest>>), do: {:ok, "5.1", rest}
  def decode(<<52::size(16), rest>>), do: {:ok, "5.2", rest}
  def decode(<<61::size(16), rest>>), do: {:ok, "6.1", rest}
  def decode(<<62::size(16), rest>>), do: {:ok, "6.2", rest}
  def decode(<<53::size(16), rest>>), do: {:ok, "6.3", rest}
  def decode(_), do: {:error, :unsupported}

  @spec encode(bitstring() | atom()) :: {:ok, bitstring()}
  # 1.0 - Default value
  def encode("1.0"), do: encode(:default)
  def encode(:default), do: {:ok, <<10::size(16)>>}

  # 1.1 - File is a volume label
  def encode("1.1"), do: encode(:volume)
  def encode(:volume), do: {:ok, <<11::size(16)>>}

  # 2.0 - File is a folder (directory)
  # 2.0 - File is compressed using Deflate compression
  # 2.0 - File is encrypted using traditional PKWARE encryption
  def encode("2.0"), do: encode(:folder)
  def encode(:folder), do: {:ok, <<20::size(16)>>}
  def encode(:deflate), do: {:ok, <<20::size(16)>>}
  def encode(:pkware_encryption), do: {:ok, <<20::size(16)>>}

  # 2.1 - File is compressed using Deflate64(tm)
  def encode("2.1"), do: encode(:deflate64)
  def encode(:deflate64), do: {:ok, <<21::size(16)>>}

  # 2.5 - File is compressed using PKWARE DCL Implode
  def encode("2.5"), do: encode(:pkware_dcl_implode)
  def encode(:pkware_dcl_implode), do: {:ok, <<25::size(16)>>}

  # 2.7 - File is a patch data set
  def encode("2.7"), do: encode(:patch_data)
  def encode(:patch_data), do: {:ok, <<27::size(16)>>}

  # 4.5 - File uses ZIP64 format extensions
  def encode("4.5"), do: encode(:zip64)
  def encode(:zip64), do: {:ok, <<45::size(16)>>}

  # 4.6 - File is compressed using BZIP2 compression*
  def encode("4.6"), do: encode(:bzip2)
  def encode(:bzip2), do: {:ok, <<46::size(16)>>}

  # 5.0 - File is encrypted using DES
  # 5.0 - File is encrypted using 3DES
  # 5.0 - File is encrypted using original RC2 encryption
  # 5.0 - File is encrypted using RC4 encryption
  def encode("5.0"), do: encode(:des)
  def encode(:des), do: {:ok, <<50::size(16)>>}
  def encode(:'3des'), do: {:ok, <<50::size(16)>>}
  def encode(:rc2), do: {:ok, <<50::size(16)>>}
  def encode(:rc4), do: {:ok, <<50::size(16)>>}

  # 5.1 - File is encrypted using AES encryption
  # 5.1 - File is encrypted using corrected RC2 encryption**
  def encode("5.1"), do: encode(:aes)
  def encode(:aes), do: {:ok, <<51::size(16)>>}
  def encode(:rc2_corrected), do: {:ok, <<51::size(16)>>}

  # 5.2 - File is encrypted using corrected RC2-64 encryption**
  def encode("5.2"), do: encode(:rc264)
  def encode(:rc264_corrected), do: {:ok, <<52::size(16)>>}

  # 6.1 - File is encrypted using non-OAEP key wrapping***
  def encode("6.1"), do: encode(:oaep)
  def encode(:oaep), do: {:ok, <<61::size(16)>>}

  # 6.2 - Central directory encryption
  def encode("6.2"), do: encode(:directory_encryption)
  def encode(:directory_encryption), do: {:ok, <<62::size(16)>>}

  # 6.3 - File is compressed using LZMA
  # 6.3 - File is compressed using PPMd+
  # 6.3 - File is encrypted using Blowfish
  # 6.3 - File is encrypted using Twofish
  def encode("6.3"), do: encode(:lzma)
  def encode(:lzma), do: {:ok, <<63::size(16)>>}
  def encode(:ppmd), do: {:ok, <<63::size(16)>>}
  def encode(:blowfish), do: {:ok, <<63::size(16)>>}
  def encode(:twofish), do: {:ok, <<63::size(16)>>}

  def encode(_), do: {:error, :unsupported}

  @spec encode(bitstring() | atom(), bitstring()) :: {:ok, bitstring()}
  def encode(version, data) do
    case encode(version) do
      {:ok, content} -> {:ok, <<data, content::size(16)>>}
      {:error, error} -> {:error, error}
    end
  end
end
