defmodule Dotzip.MixProject do
  use Mix.Project

  def project do
    [
      app: :dotzip,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      name: "DotZip",
      source_url: "https://github.com/niamtokik/dotzip",
      homepage_url: "https://github.com/niamtokik/dotzip",
      docs: [
        main: "DotZip"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
