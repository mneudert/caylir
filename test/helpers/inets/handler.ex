defmodule Caylir.TestHelpers.Inets.Handler do
  @moduledoc false

  require Record

  Record.defrecord(:mod, Record.extract(:mod, from_lib: "inets/include/httpd.hrl"))

  def serve(mod_data), do: serve_uri(mod(mod_data, :request_uri), mod_data)

  defp serve_uri('/api/v1/query/timeout', _mod_data) do
    :timer.sleep(100)
    serve_dummy()
  end

  defp serve_uri('/api/v1/query/timeout_long', _mod_data) do
    :timer.sleep(10000)
    serve_dummy()
  end

  defp serve_dummy() do
    body = '{"result": "dummy"}'

    head = [
      code: 200,
      content_length: body |> length() |> Kernel.to_charlist(),
      content_type: 'application/json'
    ]

    {:proceed, [{:response, {:response, head, body}}]}
  end
end
