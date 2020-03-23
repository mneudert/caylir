defmodule Caylir.Graph.JSONLibraryTest do
  use ExUnit.Case, async: true

  defmodule JSONGraphModule do
    alias Caylir.Graph.JSONLibraryTest.JSONLibrary

    use Caylir.Graph,
      config: [
        json_decoder: JSONLibrary,
        json_encoder: JSONLibrary
      ]
  end

  defmodule JSONGraphPartial do
    alias Caylir.Graph.JSONLibraryTest.JSONLibrary

    use Caylir.Graph,
      config: [
        json_decoder: {JSONLibrary, :decode_partial},
        json_encoder: {JSONLibrary, :encode_partial}
      ]
  end

  defmodule JSONGraphFull do
    alias Caylir.Graph.JSONLibraryTest.JSONLibrary

    use Caylir.Graph,
      config: [
        json_decoder: {JSONLibrary, :decode_full, [[keys: :atoms]]},
        json_encoder: {JSONLibrary, :encode_full, []}
      ]
  end

  defmodule JSONLibrary do
    alias Caylir.Graph.JSONLibraryTest.JSONLogger

    def decode!(data) do
      JSONLogger.log(:decode_module)
      Jason.decode!(data, keys: :atoms)
    end

    def decode_partial(data) do
      JSONLogger.log(:decode_partial)
      Jason.decode!(data, keys: :atoms)
    end

    def decode_full(data, keys: :atoms) do
      JSONLogger.log(:decode_full)
      Jason.decode!(data, keys: :atoms)
    end

    def encode!(data) do
      JSONLogger.log(:encode_module)
      Jason.encode!(data)
    end

    def encode_full(data) do
      JSONLogger.log(:encode_full)
      Jason.encode!(data)
    end

    def encode_partial(data) do
      JSONLogger.log(:encode_partial)
      Jason.encode!(data)
    end
  end

  defmodule JSONLogger do
    use Agent

    def start_link(_), do: Agent.start_link(fn -> [] end, name: __MODULE__)

    def log(action), do: Agent.update(__MODULE__, fn actions -> [action | actions] end)
    def flush, do: Agent.get_and_update(__MODULE__, &{&1, []})
  end

  test "json library configuration", context do
    start_supervised!(JSONLogger)
    start_supervised!(JSONGraphFull)
    start_supervised!(JSONGraphModule)
    start_supervised!(JSONGraphPartial)

    quad = %{subject: "json_library", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('json_library').Out('for').All()"

    _ = JSONGraphModule.write(quad)
    _ = JSONGraphModule.query(query)

    assert [:decode_module, :decode_module, :encode_module] = JSONLogger.flush()

    _ = JSONGraphPartial.write(quad)
    _ = JSONGraphPartial.query(query)

    assert [:decode_partial, :decode_partial, :encode_partial] = JSONLogger.flush()

    _ = JSONGraphFull.write(quad)
    _ = JSONGraphFull.query(query)

    assert [:decode_full, :decode_full, :encode_full] = JSONLogger.flush()
  end
end
