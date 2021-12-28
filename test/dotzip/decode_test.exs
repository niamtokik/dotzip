defmodule Dotzip.DecodeTest do
  use ExUnit.Case, async: true

  test "decode a simple archive with one file" do
    file = "test/fixtures/a.zip"
    _decoded = [
      %{
        :type => :file,
        :name => "a.txt",
        :crc => <<0xdd, 0xea, 0xa1, 0x07>>,
        :offset => 0,
        :origin => "Unix",
        :time => <<>>,
        :date => <<>>,
        :version => "3.0",
        :compression => :none,
        :encryption => :none,
        :extended_local_header => false,
        :compressed_size => 2,
        :uncompressed_size => 2,
        :filename_length => 5,
        :extra_field_length => 24,
        :comment_length => 0,
        :method => :stored,
        :command => :none,
        :extra_field => %{
          :unix => %{

          }
        },
        :content => "a\n"
      }
    ]
    {:ok, _content} = File.read(file)
    :ok
  end

  # @file "test/fixtures/directory.zip"
  # test "decode a simple archive with 2 files and a directory" do
  #   {:ok, _content} = File.read(@file)
  # end

end
