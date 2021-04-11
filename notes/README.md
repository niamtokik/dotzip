---
---

This documentation is a work in progress regarding the way to use
Dotzip Elixir module. It should:

 * be easy to understand (e.g. easy API)
 * compatible with Erlang/Elixir release
 * portable to any systems supported by Erlang/Elixir
 * usable as stream of data
 * offering an high level representation of the data/metadata
 * easy to debug

# Elixir

## ZIP File Creation

Some example of the usage. Creating a zip file should be easy and only
based on a simple object creation.

```elixir
Dotzip.new()
|> Dotzip.to_binary()
```

Adding file should also be easy. Those files are loaded only when the
file is converted in binary.

```elixir
Dotzip.new()
|> Dotzip.file("/path/to/file/one", "/one")
|> Dotzip.file("/path/to/file/two", "/two")
|> Dotzip.to_binary()
```

It should also be possible to add recursively the content of a
directory.

```elixir
Dotzip.new()
|> Dotzip.directory("/path/to/directory", recursive: true)
|> Dotzip.to_binary()
```

A blob is any kind of data direcly stored in memory, from the BEAM. 

```elixir
Dotzip.new()
|> Dotzip.blob("my raw data here", "/file_path")
|> Dotzip.blob("another content", "/file_path2")
|> Dotzip.to_binary()
```

The option of the zip file can be added directly when the zip is
created.

```elixir
Dotzip.new(compression: :unshrink)
```

A list of supported compression methods can be found directly in the
library.

```elixir
Dotzip.compression_methods()
```

Encrypted archive should also be made during the ZIP file creation.

```elixir
Dotzip.new(encryption: :aes_cbc256)
```

or by configuring it after the object was created.

```elixir
Dotzip.new()
|> Dotzip.hash(:md5)
|> Dotzip.encryption(:aes_cbc256, password: "my_password")
```

Supported method can be printed.

```elixir
Dotzip.encryption_methods()
```

## ZIP File Extraction

Extract all file from a local archive, present on the filesystem.

```elixir
Dotzip.open_file("/path/to/file.zip")
|> Dotzip.extract_all()
```

Extract only one or many files from the local archive.

```elixir
Dotzip.open_file("/path/to/file.zip")
|> Dotzip.extract("/path/compressed/file")
|> Dotzip.extract("/path/to/compressed.data")
```

Convert the full archive in erlang/elixir term.

```elixir
Dotzip.open_file("/path/to/file.zip")
|> Dotzip.to_term()
```

Convert a stream archive to erlang/elixir term.

```elixir
Dotzip.open_stream(mydata)
|> Dotzip.to_term()
```
