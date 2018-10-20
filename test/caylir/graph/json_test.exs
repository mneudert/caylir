defmodule Caylir.Graph.JSONLibraryTest do
  use ExUnit.Case, async: true

  defmodule JSONGraph do
    alias Caylir.Graph.JSONLibraryTest.JSONLibrary

    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        host: "localhost",
        port: 64210,
        json_decoder: {JSONLibrary, :decode!, [[keys: :atoms]]},
        json_encoder: JSONLibrary
      ]
  end

  defmodule JSONLibrary do
    alias Caylir.Graph.JSONLibraryTest.JSONLogger

    def encode!(data) do
      JSONLogger.log({:encode, data})
      Poison.encode!(data)
    end

    def decode!(data, options) do
      JSONLogger.log({:decode, data})
      Poison.decode!(data, options)
    end
  end

  defmodule JSONLogger do
    def start_link(), do: Agent.start_link(fn -> [] end, name: __MODULE__)

    def log(action), do: Agent.update(__MODULE__, fn actions -> [action | actions] end)
    def get(), do: Agent.get(__MODULE__, & &1)
  end

  test "json runtime configuration", context do
    {:ok, _} = JSONLogger.start_link()
    {:ok, _} = Supervisor.start_link([JSONGraph], strategy: :one_for_one)

    quad = %{subject: "json_library", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('json_library').Out('for').All()"

    _ = JSONGraph.write(quad)
    _ = JSONGraph.query(query)

    assert [{:decode, _}, {:decode, _}, {:encode, _}] = JSONLogger.get()
  end
end
