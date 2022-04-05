defmodule Caylir.MixProject do
  use Mix.Project

  @url_github "https://github.com/mneudert/caylir"
  @version "2.0.0-dev"

  def project do
    [
      app: :caylir,
      name: "Caylir",
      version: @version,
      elixir: "~> 1.9",
      deps: deps(),
      description: "Cayley driver for Elixir",
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application, do: []

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.0", only: :test, runtime: false},
      {:hackney, "~> 1.6"},
      {:jason, "~> 1.0"},
      {:ranch, "~> 1.7.0", only: :test}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :race_conditions,
        :underspecs,
        :unmatched_returns
      ],
      plt_core_path: "plts",
      plt_local_path: "plts"
    ]
  end

  defp docs do
    [
      main: "Caylir.Graph",
      formatters: ["html"],
      source_ref: "v#{@version}",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @url_github}
    }
  end
end
