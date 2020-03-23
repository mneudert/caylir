defmodule Caylir.Graph.ConfigTest do
  use ExUnit.Case, async: true

  test "runtime configuration changes" do
    graph = Module.concat([__MODULE__, RuntimeChanges])
    key = :runtime_testing_key

    Application.put_env(:caylir, graph, foo: :bar)

    defmodule graph do
      use Caylir.Graph, otp_app: :caylir
    end

    refute Keyword.has_key?(graph.config(), key)

    Application.put_env(:caylir, graph, Keyword.put(graph.config(), key, :exists))

    assert Keyword.get(graph.config(), key) == :exists
  end

  test "inline configuration defaults" do
    graph = Module.concat([__MODULE__, DefaultConfig])
    key = :inline_config_key

    defmodule graph do
      use Caylir.Graph,
        otp_app: :caylir,
        config: [{key, "inline value"}]
    end

    assert Keyword.get(graph.config(), key) == "inline value"

    Application.put_env(:caylir, graph, Keyword.put(graph.config(), key, "runtime value"))

    assert Keyword.get(graph.config(), key) == "runtime value"
  end
end
