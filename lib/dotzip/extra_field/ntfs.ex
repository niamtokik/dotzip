defmodule Dotzip.ExtraField.Ntfs do

  @moduledoc """

      The following is the layout of the NTFS attributes 
      "extra" block. (Note: At this time the Mtime, Atime
      and Ctime values MAY be used on any WIN32 system.)  

      Note: all fields stored in Intel low-byte/high-byte order.

        Value      Size       Description
        -----      ----       -----------
        0x000a     2 bytes    Tag for this "extra" block type
        TSize      2 bytes    Size of the total "extra" block
        Reserved   4 bytes    Reserved for future use
        Tag1       2 bytes    NTFS attribute tag value #1
        Size1      2 bytes    Size of attribute #1, in bytes
        (var)      Size1      Attribute #1 data
         .
         .
         .
         TagN       2 bytes    NTFS attribute tag value #N
         SizeN      2 bytes    Size of attribute #N, in bytes
         (var)      SizeN      Attribute #N data

       For NTFS, values for Tag1 through TagN are as follows:
       (currently only one set of attributes is defined for NTFS)

         Tag        Size       Description
         -----      ----       -----------
         0x0001     2 bytes    Tag for attribute #1 
         Size1      2 bytes    Size of attribute #1, in bytes
         Mtime      8 bytes    File last modification time
         Atime      8 bytes    File last access time
         Ctime      8 bytes    File creation time

  """
  
  defstruct tsize: 0, reserved: <<>>, mtime: 0, atime: 0, ctime: 0, tags: []

  def tag(), do: <<0x00, 0x0a>>

end
