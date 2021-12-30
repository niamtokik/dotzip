defmodule Dotzip.Crc32_test do
  use ExUnit.Case, async: true

  test "crc32 on bitstring" do
    {:ok, <<161, 7>>} = Dotzip.Crc32.raw("a\n")
    {:ok, <<137, 193>>} = Dotzip.Crc32.raw("file\n")
  end

  test "crc32 on file" do
    {:ok, "B5"} = Dotzip.Crc32.file("test/fixtures/a.zip")
  end

end
