defmodule Caylir.Errors.TimeoutTest do
  use ExUnit.Case, async: true

  defmodule InetsGraph do
    use Caylir.Graph, otp_app: :caylir
  end

  defmodule InetsHandler do
    require Record

    Record.defrecord(:mod, Record.extract(:mod, from_lib: "inets/include/httpd.hrl"))

    def unquote(:do)(mod_data) do
      case mod(mod_data, :request_uri) do
        '/api/v1/query/timeout_long' -> :timer.sleep(10_000)
        _ -> :timer.sleep(100)
      end

      body = '{"result": "dummy"}'

      head = [
        code: 200,
        content_length: body |> length() |> Kernel.to_charlist(),
        content_type: 'application/json'
      ]

      {:proceed, [{:response, {:response, head, body}}]}
    end
  end

  setup_all do
    root = String.to_charlist(__DIR__)

    httpd_config = [
      document_root: root,
      modules: [InetsHandler],
      port: 0,
      server_name: 'caylir_inets_proxy_timeout_test',
      server_root: root
    ]

    {:ok, httpd_pid} = :inets.start(:httpd, httpd_config)

    inets_env = [
      port: :httpd.info(httpd_pid)[:port]
    ]

    Application.put_env(:caylir, InetsGraph, inets_env)

    start_supervised!(InetsGraph)

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

    assert {:error, :timeout} == InetsGraph.delete(%{invalid: "quad"}, opts)
    assert {:error, :timeout} == InetsGraph.query("", opts)
    assert {:error, :timeout} == InetsGraph.shape("", opts)
    assert {:error, :timeout} == InetsGraph.write(%{invalid: "quad"}, opts)
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
