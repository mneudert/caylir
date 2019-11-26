defmodule Caylir.MixProject do
  use Mix.Project

  @url_github "https://github.com/mneudert/caylir"

  def project do
    [
      app: :caylir,
      name: "Caylir",
      version: "1.0.0-dev",
      elixir: "~> 1.7",
      deps: deps(),
      description: "Cayley driver for Elixir",
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application, do: []

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.12", only: :test, runtime: false},
      {:hackney, "~> 1.6"},
      {:jason, "~> 1.0"},
      {:ranch, "~> 2.0.0-rc", only: :test, runtime: false}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :race_conditions,
        :underspecs,
        :unmatched_returns
      ]
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
