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

  test "invalid shape query string" do
    shape = DefaultGraph.shape("meh!")

    assert is_map(shape)
    assert 0 == map_size(shape)
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

  test "quad lifecycle (bulk)", context do
    quads = [
      %{subject: "bulk_lifecycle", predicate: "for", object: "#{context.test} #1"},
      %{subject: "bulk_lifecycle", predicate: "for", object: "#{context.test} #2"}
    ]

    query = "graph.Vertex('bulk_lifecycle').Out('for').All()"
    result = [%{id: "#{context.test} #1"}, %{id: "#{context.test} #2"}]

    assert :ok == DefaultGraph.write(quads)
    assert result == DefaultGraph.query(query)
    assert :ok == DefaultGraph.delete(quads)
    assert nil == DefaultGraph.query(query)
  end

  test "query shape", context do
    quad = %{subject: "shapecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('shapecycle').Out('for').All()"

    :ok = DefaultGraph.write(quad)
    shape = DefaultGraph.shape(query)

    assert Map.has_key?(shape, :links)
    assert Map.has_key?(shape, :nodes)

    assert 4 == Enum.count(shape.nodes)
  end
end
