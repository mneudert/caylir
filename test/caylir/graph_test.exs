defmodule Caylir.GraphTest do
  use ExUnit.Case, async: true

  alias Caylir.TestHelpers.Graphs.DefaultGraph

  test "invalid quads fail deleting" do
    {:error, reason} = DefaultGraph.delete(%{invalid: "quad"})

    assert String.contains?(reason, "invalid quad")
  end

  test "invalid quads fail writing" do
    {:error, reason} = DefaultGraph.write(%{invalid: "quad"})

    assert String.contains?(reason, "invalid quad")
  end

  test "invalid query string" do
    {:error, reason} = DefaultGraph.query("meh!")

    assert String.contains?(reason, "Unexpected token")
  end

  @tag cayley_version: "0.6.1"
  test "invalid shape query string (0.6.1)" do
    shape = DefaultGraph.shape("meh!")

    assert is_map(shape)
    assert 0 == map_size(shape)
  end

  @tag cayley_version: "0.7.0"
  test "invalid shape query string (0.7.0)" do
    {:error, reason} = DefaultGraph.shape("meh!")

    assert String.contains?(reason, "Unexpected token")
  end

  test "quad lifecycle", context do
    quad = %{subject: "lifecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('lifecycle').Out('for').All()"
    result = [%{id: to_string(context.test)}]

    assert :ok == DefaultGraph.write(quad)
    assert result == DefaultGraph.query(query)
    assert :ok == DefaultGraph.delete(quad)
    assert nil == DefaultGraph.query(query)
  end

  test "query shape", context do
    quad = %{subject: "shapecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('shapecycle').Out('for').All()"

    :ok = DefaultGraph.write(quad)
    shape = DefaultGraph.shape(query)

    assert Map.has_key?(shape, :links)
    assert Map.has_key?(shape, :nodes)
  end

  @tag cayley_version: "0.7.0"
  test "query result limiting", context do
    quads = [
      %{subject: "query_limiting", predicate: "for", object: "#{context.test} #1"},
      %{subject: "query_limiting", predicate: "for", object: "#{context.test} #2"}
    ]

    query = "graph.Vertex('query_limiting').Out('for').All()"

    assert :ok == DefaultGraph.write(quads)

    assert 2 == length(DefaultGraph.query(query))
    assert 2 == length(DefaultGraph.query(query, [limit: -1]))
    assert 1 == length(DefaultGraph.query(query, [limit: 1]))

    assert :ok == DefaultGraph.delete(quads)
  end
end
