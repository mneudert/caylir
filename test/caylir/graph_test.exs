defmodule Caylir.GraphTest do
  use ExUnit.Case, async: true

  defmodule DefaultGraph do
    # credo:disable-for-lines:6 Credo.Check.Readability.LargeNumbers
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        host: "localhost",
        port: 64210
      ]
  end

  defmodule LimitGraph do
    # credo:disable-for-lines:7 Credo.Check.Readability.LargeNumbers
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        host: "localhost",
        limit: 1,
        port: 64210
      ]
  end

  test "missing :otp_app raises when compiling" do
    assert_raise ArgumentError, ~r/missing :otp_app.+MissingOTPAppGraph/, fn ->
      defmodule MissingOTPAppGraph do
        use Caylir.Graph
      end
    end
  end

  test "invalid quads fail deleting" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:error, reason} = DefaultGraph.delete(%{invalid: "quad"})

    assert String.contains?(reason, "invalid quad")
  end

  test "invalid quads fail writing" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:error, reason} = DefaultGraph.write(%{invalid: "quad"})

    assert String.contains?(reason, "invalid quad")
  end

  test "invalid query string" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:error, reason} = DefaultGraph.query("meh!")

    assert String.contains?(reason, "Unexpected token")
  end

  test "invalid shape query string" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:error, reason} = DefaultGraph.shape("meh!")

    assert String.contains?(reason, "Unexpected token")
  end

  test "quad lifecycle", context do
    {:ok, _} = start_supervised(DefaultGraph)

    quad = %{subject: "lifecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('lifecycle').Out('for').All()"
    result = [%{id: to_string(context.test)}]

    assert :ok == DefaultGraph.write(quad)
    assert result == DefaultGraph.query(query)
    assert :ok == DefaultGraph.delete(quad)
    assert nil == DefaultGraph.query(query)
  end

  test "query shape", context do
    {:ok, _} = start_supervised(DefaultGraph)

    quad = %{subject: "shapecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('shapecycle').Out('for').All()"

    :ok = DefaultGraph.write(quad)
    shape = DefaultGraph.shape(query)

    assert Map.has_key?(shape, :links)
    assert Map.has_key?(shape, :nodes)
  end

  test "query result limiting", context do
    {:ok, _} = start_supervised(LimitGraph)

    quads = [
      %{subject: "query_limiting", predicate: "for", object: "#{context.test} #1"},
      %{subject: "query_limiting", predicate: "for", object: "#{context.test} #2"}
    ]

    # `All()` only respects limit in cayley 0.7.4+
    # graph.Vertex('query_limiting').Out('for').All()"
    query = "graph.Vertex('query_limiting').Out('for').ForEach( function(d) { g.Emit(d) })"

    assert :ok == LimitGraph.write(quads)

    assert 1 == length(LimitGraph.query(query))
    assert 2 == length(LimitGraph.query(query, limit: -1))
    assert 1 == length(LimitGraph.query(query, limit: 1))

    assert :ok == LimitGraph.delete(quads)
  end
end
