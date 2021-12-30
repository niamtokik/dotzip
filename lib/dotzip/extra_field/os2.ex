defmodule Dotzip.ExtraField.Os2 do

  @moduledoc """

      The following is the layout of the OS/2 attributes "extra" 
      block.  (Last Revision  09/05/95)

      Note: all fields stored in Intel low-byte/high-byte order.

        Value       Size          Description
        -----       ----          -----------
        0x0009      2 bytes       Tag for this "extra" block type
        TSize       2 bytes       Size for the following data block
        BSize       4 bytes       Uncompressed Block Size
        CType       2 bytes       Compression type
        EACRC       4 bytes       CRC value for uncompress block
        (var)       variable      Compressed block

      The OS/2 extended attribute structure (FEA2LIST) is 
      compressed and then stored in its entirety within this 
      structure.  There will only ever be one "block" of data in 
      VarFields[].

  """
  
  defstruct ctype: 0, block: <<>>

  def tag(), do: <<0x00, 0x09>>
  
  def encode(_data), do: {:error, :not_implemented}

  def decode(_data), do: {:error, :not_implemented}
  
end
