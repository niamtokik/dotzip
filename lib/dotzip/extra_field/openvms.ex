defmodule Dotzip.ExtraField.Openvms do

  @moduledoc """

       The following is the layout of the OpenVMS attributes 
       "extra" block.

       Note: all fields stored in Intel low-byte/high-byte order.

         Value      Size       Description
         -----      ----       -----------
         0x000c     2 bytes    Tag for this "extra" block type
         TSize      2 bytes    Size of the total "extra" block
         CRC        4 bytes    32-bit CRC for remainder of the block
         Tag1       2 bytes    OpenVMS attribute tag value #1
         Size1      2 bytes    Size of attribute #1, in bytes
         (var)      Size1      Attribute #1 data
         .
         .
         .
         TagN       2 bytes    OpenVMS attribute tag value #N
         SizeN      2 bytes    Size of attribute #N, in bytes
         (var)      SizeN      Attribute #N data

       OpenVMS Extra Field Rules:

          4.5.6.1. There will be one or more attributes present, which 
          will each be preceded by the above TagX & SizeX values.  
          These values are identical to the ATR$C_XXXX and ATR$S_XXXX 
          constants which are defined in ATR.H under OpenVMS C.  Neither 
          of these values will ever be zero.

          4.5.6.2. No word alignment or padding is performed.

          4.5.6.3. A well-behaved PKZIP/OpenVMS program should never produce
          more than one sub-block with the same TagX value.  Also, there will 
          never be more than one "extra" block of type 0x000c in a particular 
          directory record.

  """

  defstruct tsize: 0, crc: 0, tags: []

  def tag(), do: <<0x00, 0x0c>>
  
end
  
