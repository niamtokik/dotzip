defmodule Dotzip.LocalFileHeaderTest do
  use ExUnit.Case, async: true

  test "decode simple craft local file header" do
    local_file_header= <<>>
    Dotzip.LocalFileheader.decode(local_file_header)
  end

end
