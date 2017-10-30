defmodule Caylir.TestHelpers.Inets.Handler do
  @moduledoc false

  require Record

  Record.defrecord(:mod, Record.extract(:mod, from_lib: "inets/include/httpd.hrl"))

  def serve(mod_data), do: serve_uri(mod(mod_data, :request_uri), mod_data)

  defp serve_uri('/api/v1/query/gremlin', _mod_data) do
    body = '{"result": "dummy"}'

    head = [
      code: 200,
      content_length: body |> length() |> Kernel.to_charlist(),
      content_type: 'application/json'
    ]

    {:proceed, [{:response, {:response, head, body}}]}
  end
end
