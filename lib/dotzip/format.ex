# https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-dosdatetimetofiletime?redirectedfrom=MSDN

defmodule Dotzip.Format.Msdos do

  def decode_date(<<day::size(5), month::size(4), offset::size(7)>>) do
    Date.new(1980+offset, month, day)
  end

  def decode_time(<<second::size(5), minute::size(6), hour::size(5)>>) do
    Time.new(hour, minute, second*2, 0)
  end
  
end
