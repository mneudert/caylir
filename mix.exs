defmodule Caylir.Mixfile do
  use Mix.Project

  @url_github "https://github.com/mneudert/caylir"

  def project do
    [ app:           :caylir,
      name:          "Caylir",
      description:   "Cayley driver for Elixir",
      package:       package,
      version:       "0.3.0-dev",
      elixir:        "~> 1.0",
      deps:          deps(Mix.env),
      docs:          docs,
      test_coverage: [ tool: ExCoveralls ]]
  end

  def application do
    [ applications: [ :hackney, :poison, :poolboy ] ]
  end

  def deps(:docs) do
    deps(:prod) ++
      [ { :earmark, "~> 0.2",  optional: true },
        { :ex_doc,  "~> 0.11", optional: true } ]
  end

  def deps(:test) do
    deps(:prod) ++
      [ { :dialyze,     "~> 0.2", optional: true },
        { :excoveralls, "~> 0.4", optional: true } ]
  end

  def deps(_) do
    [ { :hackney, "~> 1.1" },
      { :poison,  "~> 1.4 or ~> 2.0" },
      { :poolboy, "~> 1.5" } ]
  end

  def docs do
    [ extras:     [ "CHANGELOG.md", "README.md" ],
      main:       "README",
      source_ref: "master",
      source_url: @url_github ]
  end

  def package do
    %{ files:       [ "CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib" ],
       licenses:    [ "Apache 2.0" ],
       links:       %{ "GitHub" => @url_github },
       maintainers: [ "Marc Neudert" ]}
  end
end
