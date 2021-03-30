# Dotzip

> ZIP is one of the most widely used compressed file formats. It is
> universally used to aggregate, compress, and encrypt files into a
> single interoperable container. No specific use or application need
> is defined by this format and no specific implementation guidance is
> provided. This document provides details on the storage format for
> creating ZIP files.  Information is provided on the records and
> fields that describe what a ZIP file is. -- from [official
> specification
> file](https://pkware.cachefly.net/webdocs/APPNOTE/APPNOTE-6.3.3.TXT)

Note: This project is a work in progress. Please don't use it in
production.

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

## Trademarks

> PKWARE, PKZIP, SecureZIP, and PKSFX are registered trademarks of
> PKWARE, Inc. in the United States and elsewhere.  PKPatchMaker,
> Deflate64, and ZIP64 are trademarks of PKWARE, Inc.  Other marks
> referenced within this document appear for identification purposes
> only and are the property of their respective owners.

## Notes

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dotzip](https://hexdocs.pm/dotzip).

