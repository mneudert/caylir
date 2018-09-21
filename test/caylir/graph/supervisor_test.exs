defmodule Caylir.Graph.SupervisorTest do
  use ExUnit.Case, async: true

  defmodule Initializer do
    def start_link, do: Agent.start_link(fn -> nil end, name: __MODULE__)

    def call_init(graph), do: Agent.update(__MODULE__, fn _ -> graph end)
    def get_init, do: Agent.get(__MODULE__, & &1)
  end

  defmodule InitializerGraph do
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        init: {Caylir.Graph.SupervisorTest.Initializer, :call_init}
      ]
  end

  test "init function called upon graph (re-) start" do
    {:ok, _} = Initializer.start_link()
    {:ok, _} = Supervisor.start_link([InitializerGraph], strategy: :one_for_one)

    assert InitializerGraph == Initializer.get_init()
  end
end
