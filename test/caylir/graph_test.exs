defmodule Caylir.GraphTest do
  use ExUnit.Case, async: true

  defmodule TestGraph do
    use Caylir.Graph

    def conf(), do: [ host: "localhost", port: 64210 ]
  end

  setup context do
    Supervisor.start_link([], name: context.test, strategy: :one_for_one)
    Supervisor.start_child(context.test, TestGraph.child_spec)

    :ok
  end

  test "graph startup", context do
    assert [{ TestGraph, _, _, _ }] = Supervisor.which_children(context.test)
  end

  test "invalid quads fail deleting" do
    { :error, reason } = TestGraph.delete(%{ invalid: "quad" })

    assert String.contains?(reason, "invalid quad")
  end
  test "invalid quads fail writing" do
    { :error, reason } = TestGraph.write(%{ invalid: "quad" })

    assert String.contains?(reason, "invalid quad")
  end

  test "quad lifecycle", context do
    quad = %{ subject: "quad", predicate: "lifetime", object: context.test }

    assert :ok = TestGraph.write(quad)
    assert :ok = TestGraph.delete(quad)
  end
end
