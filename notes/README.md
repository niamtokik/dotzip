This documentation is a work in progress regarding the way to use
Dotzip Elixir module. This module should:

 * **be easy to understand (e.g. easy API)**: interfaces should follow
   OTP and/or Elixir principles. Anyone who want to use it should
   simply read introduction page. The documentation should cover 99%
   of user requirement but can offer also some "expert" feature.
 
 * **be compatible with Erlang/Elixir release**: this project should
   be compatible with BEAP virtual machine and usable with other
   languages like Joxa, Clojuerl, Erlang and Elixir.
 
 * **be portable to any systems supported by Erlang/Elixir**: it
   should work on any "recent" version of OTP (>R19).
 
 * **be usable as stream of data**: this project should not have a
   high memory impact, if an archive is too big, it should not be a
   problem to use it in small systems.
 
 * **offer an high level representation of the data/metadata**: a
   clean representation of ZIP archive should be generated and
   hackable. Anyone who want to design his own module or feature
   should have all information to do it.
 
 * **have no external requirement or dependencies**: this project
   should not use any external project, except if the dependency is
   vital for the project.
 
 * **be easy to debug**: parsing, encoding and decoding files can be
   quite complex, this project should offer enough function to let
   anyone debug this project and other ZIP related projects.
   
 * **offer a framework**: this project is a first step to create an
   archive framework, where anyone can archive and compress data in
   any kind of format.
   
 * **offer benchmark**: this project should be benchmarked and
   generate stats.

 * **offer different way to use**: the first target is to use this
   project as library but, it could be nice to use it as compression
   daemon and/or system tool.

# Dotzip Documentation Draft

(Work in progress) Dotzip can be used as library or as OTP
application. As library, Dotzip act as a highlevel interface for
creating Zip files. As OTP application, Dotzip act as a framework to
create, analyze or extract Zip archives by using optimized
functions. To use it as application, users will need to start `Dotzip`
application.

```
Application.start(:dotzip)
```

(Work in progress) One can also stop it.

```
Application.stop(:dotzip)
```

## Dotzip Library

(Work in progress) To decode a Zip file from bitstring, one can use
`Dotzip.decode/1` or `Dotzip.decode/2` functions.

```elixir
{:ok, dotzip} = Dotzip.decode(bitstring)
```

(Work in progress) In another hand, to encode abstract Dotzip data
structure as Zip file, one can use `Dotzip.encode/1` or
`Dotzip.encode/2` functions.

```elixir
{:ok, bitstring} = Dotzip.encode(dotzip)
```

(Work in progress) The structure used must be easy to understand and
should contain all information required. A Zip file is mainly divided
in 2 parts, a central directory record containing global information
about the zip file, and a list of files, each one with their own
header.

NOTE: static data-structures vs dynamic data-structures, here two
worlds are colliding, a strict decomposition of the data can be done
by using `tuples` or by using `maps`. Using `tuples` can be used on
practically any version of OTP but will require more work on the
library. In other hand, using `maps` can help to design a flexible
library but old OTP versions will be impacted. The first
implementation will use a mix between tuples and maps, all important
Dotzip datastructures will be tagged with `:dotzip_*` tag.

All the following part is a draft.

### File(s) Structure(s)

To be defined

```elixir
@type dotzip_encryption_header() :: %{}
@type dotzip_file_data() :: <<>> | {:dotzip_file_ref, <<>>}
@type dotzip_data_description() :: %{}
```

```elixir
@type dotzip_file() :: {:dotzip_file, 
  %{ dotzip_file_header, 
    :dotzip_encryption_header => dotzip_encryption_header(), 
    :dotzip_file_data => dotzip_file_data(), 
    :dotzip_data_descriptor => dotzip_data_descriptor()
  }
}
```

```elixir
@type dotzip_files() :: [dotzip_file(), ...]
```

### Central Directory Record Structure(s)

To be defined

```elixir
@type dotzip_central_directory_record() :: %{
  
}
```

```elixir
@typedoc ""
@type dotzip_struct() :: {:dotzip, 
  %{
    :dotzip_central_directory_record => dotzip_central_directory_record, 
    :dotzip_files => dotzip_files
  }
}
```

## ZIP File Extraction and Analysis

(Work in progress) A Zip file can contain many files, and sometime,
big one. To avoid using the whole memory of the system, Dotzip can
load only metadata instead of the whole archive by using
`Dotzip.preload/1` or `Dotzip.preload/2` functions.

```elixir
{:ok, reference_preload} = Dotzip.preload("/path/to/archive.zip")
```

(Work in progress) In other hand, a file can be fully loaded by using
`Dotzip.load/1` or `Dotzip.load/2` functions.

```elixir
{:ok, reference_load} = Dotzip.load("/path/to/archive.zip")
```

(Work in progress) Dotzip can analyze the content of the archive by
using `Dotzip.analyze/1` or `Dotzip.analyze/2` functions. These
functions will ensure the file is in good state or alert if something
is not correct. `Dotzip.analyze` features may be extended by using
creating `Dotzip.Analyzer`.

```elixir
{:ok, analysis} = Dotzip.analyze(reference)
```

(Work in progress) The whole archive can be extracted by using
`Dotzip.extract/2` or `Dotzip.extract/3` functions.

```elixir
{:ok, info} = Dotzip.extract(reference, "/path/to/extract")
{:ok, info} = Dotzip.extract(reference, "/other/path/to/extract", verbose: true)
```

(Work in progress) When a file is not required anymore, this file can
be unloaded by using `Dotzip.unload/1` function. Both the path of the
archive or the reference can be used.

```elixir
:ok = Dotzip.unload("/path/to/archive.zip")
:ok = Dotzip.unload(reference)
```

## ZIP File Creation

(Work in progress) Some example of the usage. Creating a zip file
should be easy and only based on a simple object creation. To create a
new empty archive, `Dotzip.new/0` or `Dotzip.new/1` functions can be
used.

```elixir
reference = Dotzip.new()
```

(Work in progress) Adding files must also be quite
easy. `Dotzip.add/2` or `Dotzip.add/3` functions can be used to add
files based on different sources. By default, absolute paths are
converted to relavative path by removing the root part of the path.

```elixir
# add a file from absolute path
{:ok, info} = Dotzip.add(reference, "/path/to/my/file")

# add a directory and its whole content from absolute path
{:ok, info} = Dotzip.add(reference, "/path/to/my/directory", recursive: true)

# create a new directory
{:ok, info} = Dotzip.add(reference, {:directory, "/my/directory"})

# create a new file in archive from bitstring
{:ok, info} = Dotzip.add(reference, {:raw, "/my/file", "content\n"}", compression: :lz4)

# create a new file from external url
{:ok, info} = Dotzip.add(reference, {:url, "/my/other/file", "https://my.super.site.com/file"})
```

(Work in progress) The whole archive can also share some specific
options, like encryption or compression.

```elixir
# set compression to lz4
Dotzip.set(reference, compression: :lz4)

Dotzip.set(reference, encryption: :aes_cbc256)
Dotzip.set(reference, passphrase: "my passphrase")
```
