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
end
