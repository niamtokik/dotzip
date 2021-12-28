defmodule Dotzip.Headers.LocalFile do

  defstruct [
    header_signature: <<0x04, 0x03, 0x4b, 0x50>>, # 4 bytes
    version: <<>>, # 2 bytes
    general_purpose_bit_flag: <<>>, # 2 bytes
    compression_method: <<>>, # 2 bytes
    last_modification_time: <<>>, # 2 bytes
    last_modification_date: <<>>, # 2 bytes

  ]

end
