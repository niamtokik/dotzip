defmodule Dotzip do

  @moduledoc ~S"""
  Elixir Implementation of ZIP File Format. This module is the main
  interface to control Dotzip application with simple, specified and
  documented functions.
  """

  @type dotzip :: []
  @type file :: String.t()
  @type opts :: Keyword.t()

  @doc ~S"""
  `start/0` function start Dotzip application with default options.

  ## Examples

      iex> Dotzip.start()
      :ok

  """
  def start(), do: start([])

  @doc ~S"""
  `start/1` function start Dotzip application with customer options.

  ## Examples

      iex> Dotzip.start([])
      :ok

  """
  def start(_opts), do: Application.start(:dotzip)

  @doc ~S"""
  check/0 function check if Dotzip application is running.

  ## Examples

      iex> Dotzip.check()
      :ok

  """
  def check(), do: :wip

  @doc ~S"""
  stop/0 function stop Dotzip application.

  ## Examples

      iex> Dotzip.stop()
      :ok

  """
  def stop(), do: Application.stop(:dotzip)

  @doc ~S"""
  See `preload/2` function.

  ## Examples

      iex> Dotzip.preload("test/fixtures/a.zip")
      {:ok, reference}

  """
  def preload(target), do: preload(target, [])

  @doc ~S"""
  `preload/2` function preload a Zip archive present on the system by
  extracting metadata and other information but not the content of
  compressed files. This function is mainly used when users need to
  work on massive archive without impacting BEAM memory.

  ## Examples

      iex> Dotzip.preload("test/fixtures/a.zip", [])
      {:ok, reference}

  """
  def preload(_target, _opts), do: :wip

  @doc ~S"""
  See `load/2` function.

  ## Examples

      iex> Dotzip.load("test/fixtures/a.zip")
      {:ok, reference}

  """
  def load(target), do: load(target, [])


  @doc ~S"""
  `load/2` function load a Zip archive present on the system. Content
  of compressed files are also stored in memory and can impact the
  whole performance of the BEAM.

  ## Examples

      iex> Dotzip.load("test/fixtures/a.zip", [])
      {:ok, reference}

  """
  def load(_target, _opts), do: :wip

  @doc ~S"""
  See `analyze/2` function.

  ## Examples

      iex> Dotzip.analyze(reference)
      {:ok, analysis}

  """
  def analyze(reference), do: analyze(reference, [])

  @doc ~S"""
  `analyze/2` function is used to analyze metadata and content of
  loaded or preload archive.

  ## Examples

      iex> Dotzip.analyze(reference, [])
      {:ok, analysis}

  """
  def analyze(_reference, _opts), do: :wip

  @doc ~S"""

  See `extract/1` function. Extract by default in `/tmp` directory on
  Unix/Linux system.

  ## Examples

      iex> Dotzip.extract(reference)
      {:ok, info}

      iex> Dotzip.extract("test/fixtures/a.zip")
      {:ok, info}

  """
  def extract(reference, target), do: extract(reference, target, [])

  @doc ~S"""
  `extract/2` function extract the content of a loaded or preloaded
  archive directly on the filesystem.

  ## Examples

      iex> Dotzip.extract(reference, "/tmp")
      {:ok, info}

      iex> Dotzip.extract("test/fixtures/a.zip", destination: "/tmp")
      {:ok, info}

  """
  def extract(_reference, _target, _opts), do: :wip

  @doc ~S"""
  `unload/1` function unload a loaded or preloaded archive.

  ## Examples

      iex> Dotzip.unload(reference)
      :ok

  """
  def unload(_reference), do: :wip

  @doc ~S"""
  See `new/1` function.

  ## Examples

      iex> Dotzip.new()
      {:ok, reference}

  """
  @spec new() :: dotzip()
  def new() do
    new([])
  end

  @doc ~S"""
  `new/1` function create a new Dotzip reference, an empty archive
  directly in memory.

  ## Examples

      iex> Dotzip.new([])
      {:ok, reference}

  """
  @spec new(opts()) :: dotzip()
  def new(_opts) do
    []
  end

  @doc ~S"""
  See `add/3` function.

  ## Examples

      iex> Dotzip.new() |> Dotzip.add("test/fixtures/a.zip")
      {:ok, info}

  """
  @spec add(dotzip(), file()) :: dotzip
  def add(zip, file) do
    add(zip, file, [])
  end

  @doc ~S"""
  `add/3` add a new file in the archive.

  ## Examples

      iex> Dotzip.new() |> Dotzip.add("test/fixtures/a.zip", compressed: :lz4)
      {:ok, info}

  """
  @spec add(dotzip(), file(), opts()) :: dotzip
  def add(zip, file, opts) when is_bitstring(file) do
    add(zip, {:file, file}, opts)
  end
  def add(zip, {:file, file}, _opts) do
    [%{name: file}|zip]
  end
  def add(zip, {:raw, file, content}, _opts) do
    [%{name: file, content: content}|zip]
  end
  def add(zip, {:external, file, _url}, _opts) do
    [%{name: file}|zip]
  end
  def add(zip, {:directory, file}, _opts) do
    [%{name: file, uncompressed_size: 0, compression_size: 0 }|zip]
  end
  def add(_zip, _file, _opts) do
  end

  @doc ~S"""
  See `delete/3` function.

  ## Examples

      iex> Dotzip.delete(reference, "/file")
      :ok

  """
  @spec delete(dotzip(), file()) :: dotzip()
  def delete(zip, file) do
    delete(zip, file, [])
  end

  @doc ~S"""
  `delete/3` function remove a file from an in memory archive.

  ## Examples

      iex> Dotzip.delete(reference, "/file", [])
      :ok

  """
  @spec delete(dotzip(), file(), opts()) :: dotzip()
  def delete(_zip, _file, _opts) do
  end

  @doc ~S"""
  See `update/4` function.
  """
  @spec update(dotzip(), file(), bitstring()) :: dotzip()
  def update(zip, file, content), do: update(zip, file, content, [])

  @doc ~S"""
  `update/4` function the content of a file, it can also alter
  metadata and other elements of the archived file.
  """
  @spec update(dotzip(), file(), bitstring(), opts()) :: dotzip()
  def update(_zip, _file, _content, _opts), do: :wip

  @doc ~S"""
  `set/2` function configure options for the whole archive.

  ## Examples

      iex> Dotzip.set(reference, compression: :lz4)
      :ok

  """
  def set(reference, opts), do: set(reference, :all, opts)

  @doc ~S"""
  `set/3` function configure options for individual archived files.

  ## Examples

      iex> Dotzip.set(reference, "path/to/my/file", compression: :lz4)
      :ok

  """
  def set(_reference, _target, _opts), do: :wip

end
