defmodule Caylir.Graph.SupervisorTest do
  use ExUnit.Case, async: true

  alias Caylir.TestHelpers.Graphs.InitGraph

  defmodule Initializer do
    def start_link, do: Agent.start_link(fn -> nil end, name: __MODULE__)

    def call_init(graph), do: Agent.update(__MODULE__, fn _ -> graph end)
    def get_init, do: Agent.get(__MODULE__, & &1)
  end

  setup do
    env = Application.get_env(:caylir, InitGraph)

    :ok =
      Application.put_env(:caylir, InitGraph, Keyword.put(env, :init, {Initializer, :call_init}))

    {:ok, _} = Initializer.start_link()

    on_exit(fn ->
      :ok = Application.put_env(:caylir, InitGraph, env)
    end)
  end

  test "init function called upon graph (re-) start" do
    _ = Supervisor.start_link([InitGraph.child_spec()], strategy: :one_for_one)
    :ok = :timer.sleep(100)

    assert InitGraph == Initializer.get_init()
  end
end
