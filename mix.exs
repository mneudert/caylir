defmodule Caylir.Mixfile do
  use Mix.Project

  @url_github "https://github.com/mneudert/caylir"

  def project do
    [ app:           :caylir,
      name:          "Caylir",
      version:       "0.1.0-dev",
      elixir:        "~> 1.0",
      deps:          deps(Mix.env),
      docs:          docs,
      test_coverage: [ tool: ExCoveralls ]]
  end

  def application do
    [ applications: [ :inets ] ]
  end

  def deps(:docs) do
    deps(:prod) ++
      [ { :earmark, "~> 0.1", optional: true },
        { :ex_doc,  "~> 0.7", optional: true } ]
  end

  def deps(:test) do
    deps(:prod) ++
      [ { :dialyze,     "~> 0.1", optional: true },
        { :excoveralls, "~> 0.3", optional: true } ]
  end

  def deps(_) do
    [ { :poison,  "~> 1.3" },
      { :poolboy, "~> 1.4" } ]
  end

  def docs do
    [ main:       "README",
      readme:     "README.md",
      source_ref: "master",
      source_url: @url_github ]
  end
end
