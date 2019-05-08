defmodule Caylir.InetsProxy.TimeoutTest do
  use ExUnit.Case, async: true

  alias Caylir.TestHelpers.Graphs.InetsGraph
  alias Caylir.TestHelpers.Inets.Handler

  setup_all do
    root = String.to_charlist(__DIR__)

    httpd_config = [
      document_root: root,
      modules: [Handler],
      port: 0,
      server_name: 'caylir_testhelpers_inets_handler',
      server_root: root
    ]

    {:ok, httpd_pid} = :inets.start(:httpd, httpd_config)

    inets_env = [
      host: "localhost",
      port: :httpd.info(httpd_pid)[:port]
    ]

    Application.put_env(:caylir, InetsGraph, inets_env)

    {:ok, _} = start_supervised(InetsGraph)

    on_exit(fn ->
      :inets.stop(:httpd, httpd_pid)
    end)
  end

  test "timeout" do
    timeout = 10

    opts = [
      language: "timeout",
      timeout: timeout
    ]

    assert {:error, :timeout} == InetsGraph.query("", opts)
  end

  test "timeout above GenServer defaults" do
    timeout = 7500

    opts = [
      language: "timeout_long",
      timeout: timeout
    ]

    assert {:error, :timeout} == InetsGraph.query("", opts)
  end
end
