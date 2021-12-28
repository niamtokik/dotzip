defmodule Dotzip.ExtraField.X509.Individual do

  def tag(), do: <<0x00, 0x15>>
  
end

defmodule Dotzip.ExtraField.X509.Central do

  def tag(), do: <<0x00, 0x16>>
  
end
