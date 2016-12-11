defmodule Caylir.Mixfile do
  use Mix.Project

  @url_github "https://github.com/mneudert/caylir"

  def project do
    [ app:     :caylir,
      name:    "Caylir",
      version: "0.3.0",
      elixir:  "~> 1.2",
      deps:    deps(),

      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      preferred_cli_env: [
        coveralls:          :test,
        'coveralls.detail': :test,
        'coveralls.travis': :test
      ],

      description:   "Cayley driver for Elixir",
      docs:          docs(),
      package:       package(),
      test_coverage: [ tool: ExCoveralls ] ]
  end

  def application do
    [ applications: [ :hackney, :poison, :poolboy ] ]
  end

  defp deps do
    [ { :ex_doc, ">= 0.0.0", only: :dev },

      { :excoveralls, "~> 0.5", only: :test },

      { :hackney, "~> 1.1" },
      { :poison,  "~> 2.0 or ~> 3.0" },
      { :poolboy, "~> 1.5" } ]
  end

  defp docs do
    [ extras:     [ "CHANGELOG.md", "README.md" ],
      main:       "readme",
      source_ref: "v0.3.0",
      source_url: @url_github ]
  end

  defp package do
    %{ files:       [ "CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib" ],
       licenses:    [ "Apache 2.0" ],
       links:       %{ "GitHub" => @url_github },
       maintainers: [ "Marc Neudert" ] }
  end
end
