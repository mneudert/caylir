defmodule Caylir.Graph.InitializerTest do
  use ExUnit.Case, async: true

  defmodule Initializer do
    use Agent

    def start_link(_), do: Agent.start_link(fn -> nil end, name: __MODULE__)

    def call_init(graph), do: call_init(graph, :ok_empty)
    def call_init(graph, result), do: Agent.update(__MODULE__, fn _ -> {graph, result} end)

    def get_init, do: Agent.get(__MODULE__, & &1)
  end

  defmodule InitializerGraphModFun do
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        init: {Caylir.Graph.InitializerTest.Initializer, :call_init}
      ]
  end

  defmodule InitializerGraphModFunArgs do
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        init: {Caylir.Graph.InitializerTest.Initializer, :call_init, [:ok_passed]}
      ]
  end

  test "init {mod, fun} called upon graph (re-) start" do
    {:ok, _} = start_supervised(Initializer)
    {:ok, _} = start_supervised(InitializerGraphModFun)

    assert {InitializerGraphModFun, :ok_empty} == Initializer.get_init()
  end

  test "init {mod, fun, args} called upon graph (re-) start" do
    {:ok, _} = start_supervised(Initializer)
    {:ok, _} = start_supervised(InitializerGraphModFunArgs)

    assert {InitializerGraphModFunArgs, :ok_passed} == Initializer.get_init()
  end
end
