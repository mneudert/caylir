defmodule Caylir.Graph.SupervisorTest do
  use ExUnit.Case, async: true

  defmodule Initializer do
    def start_link, do: Agent.start_link(fn -> nil end, name: __MODULE__)

    def call_init(graph), do: call_init(graph, :ok_empty)
    def call_init(graph, result), do: Agent.update(__MODULE__, fn _ -> {graph, result} end)

    def get_init, do: Agent.get(__MODULE__, & &1)
  end

  defmodule InitializerGraphModFun do
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        init: {Caylir.Graph.SupervisorTest.Initializer, :call_init}
      ]
  end

  defmodule InitializerGraphModFunArgs do
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        init: {Caylir.Graph.SupervisorTest.Initializer, :call_init, [:ok_passed]}
      ]
  end

  setup do
    {:ok, _} = Initializer.start_link()
    :ok
  end

  test "init {mod, fun} called upon supervisor (re-) start" do
    {:ok, _} = Supervisor.start_link([InitializerGraphModFun], strategy: :one_for_one)

    assert {InitializerGraphModFun, :ok_empty} == Initializer.get_init()
  end

  test "init {mod, fun, args} called upon supervisor (re-) start" do
    {:ok, _} = Supervisor.start_link([InitializerGraphModFunArgs], strategy: :one_for_one)

    assert {InitializerGraphModFunArgs, :ok_passed} == Initializer.get_init()
  end
end
