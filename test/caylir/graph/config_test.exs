defmodule Caylir.Graph.ConfigTest do
  use ExUnit.Case, async: true

  alias Caylir.Graph.Config

  test "otp_app configuration", %{test: test} do
    config = [foo: :bar]
    :ok = Application.put_env(test, __MODULE__, config)

    assert [otp_app: test] ++ config == Config.config(test, __MODULE__)
  end

  test "missing configuration raises" do
    exception =
      assert_raise ArgumentError, fn ->
        Config.config(:ignored, __MODULE__)
      end

    assert String.contains?(exception.message, inspect(__MODULE__))
  end

  test "runtime configuration changes" do
    graph = Module.concat([__MODULE__, RuntimeChanges])
    key = :runtime_testing_key

    Application.put_env(:caylir, graph, foo: :bar)

    defmodule graph do
      use Caylir.Graph, otp_app: :caylir
    end

    refute Keyword.has_key?(graph.config(), key)

    Application.put_env(:caylir, graph, Keyword.put(graph.config(), key, :exists))

    assert :exists == Keyword.get(graph.config(), key)
  end

  test "inline configuration defaults" do
    graph = Module.concat([__MODULE__, DefaultConfig])
    key = :inline_config_key

    defmodule graph do
      use Caylir.Graph,
        otp_app: :caylir,
        config: [{:"#{key}", "inline value"}]
    end

    assert "inline value" == graph.config()[key]

    Application.put_env(:caylir, graph, Keyword.put(graph.config(), key, "runtime value"))

    assert "runtime value" == graph.config()[key]
  end
end
