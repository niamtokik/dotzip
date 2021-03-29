# Dotzip

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dotzip` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dotzip, "~> 0.1.0"}
  ]
end
```

## Decoding Example

create a zip file

```sh
cd /tmp
echo test > test
zip test.zip test
```

extract information

```elixir
{:ok, file} = :file.read_file("/tmp/test.zip")
Dotzip.decode(file)
```

## Resources

 * https://www.loc.gov/preservation/digital/formats/fdd/fdd000362.shtml
 * https://pkware.cachefly.net/webdocs/APPNOTE/APPNOTE-6.3.3.TXT
 * https://en.wikipedia.org/wiki/ZIP_(file_format)

## Notes

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dotzip](https://hexdocs.pm/dotzip).

