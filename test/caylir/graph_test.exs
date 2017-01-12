defmodule Caylir.GraphTest do
  use ExUnit.Case, async: true

  alias CaylirTestHelpers.Graph, as: TestGraph


  test "invalid quads fail deleting" do
    { :error, reason } = TestGraph.delete(%{ invalid: "quad" })

    assert String.contains?(reason, "invalid quad")
  end

  test "invalid quads fail writing" do
    { :error, reason } = TestGraph.write(%{ invalid: "quad" })

    assert String.contains?(reason, "invalid quad")
  end

  test "invalid query string" do
    { :error, reason } = TestGraph.query("meh!")

    assert String.contains?(reason, "Unexpected token")
  end

  test "invalid shape query string" do
    shape = TestGraph.shape("meh!")

    assert is_map(shape)
    assert 0 == map_size(shape)
  end


  test "quad lifecycle", context do
    quad   = %{ subject: "lifecycle",
                predicate: "for",
                object: to_string(context.test) }
    query  = "graph.Vertex('lifecycle').Out('for').All()"
    result = [%{ id: to_string(context.test) }]

    assert :ok    == TestGraph.write(quad)
    assert result == TestGraph.query(query)
    assert :ok    == TestGraph.delete(quad)
    assert nil    == TestGraph.query(query)
  end

  test "query shape", context do
    quad  = %{ subject: "shapecycle",
               predicate: "for",
               object: to_string(context.test) }
    query = "graph.Vertex('shapecycle').Out('for').All()"

    :ok   = TestGraph.write(quad)
    shape = TestGraph.shape(query)

    assert Map.has_key?(shape, :links)
    assert Map.has_key?(shape, :nodes)

    assert 4 == Enum.count(shape.nodes)
  end
end
