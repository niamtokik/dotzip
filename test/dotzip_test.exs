defmodule DotzipTest do
  use ExUnit.Case
  doctest Dotzip

  test "local file header" do
    assert :world == :world
  end
end
