defmodule Caylir.Mixfile do
  use Mix.Project

  @url_github "https://github.com/mneudert/caylir"

  def project do
    [
      app: :caylir,
      name: "Caylir",
      version: "0.8.0",
      elixir: "~> 1.3",
      deps: deps(),
      description: "Cayley driver for Elixir",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      erlc_paths: erlc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [applications: [:hackney, :poison, :poolboy]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:hackney, "~> 1.6"},
      {:poison, "~> 3.0"},
      {:poolboy, "~> 1.5"}
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_ref: "v0.8.0",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp erlc_paths(:test), do: ["src", "test/helpers/inets"]
  defp erlc_paths(_), do: ["src"]

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
