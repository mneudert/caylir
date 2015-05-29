defmodule Caylir.GraphTest do
  use ExUnit.Case, async: true

  defmodule TestGraph do
    use Caylir.Graph

    def conf(), do: [ host: "localhost", port: 64210 ]
  end

  setup_all context do
    Supervisor.start_link([], name: context.case, strategy: :one_for_one)
    Supervisor.start_child(context.case, TestGraph.child_spec)

    :ok
  end


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
end
