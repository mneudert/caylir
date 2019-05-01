defmodule Caylir.Graph.Initializer do
  @moduledoc false

  use GenServer

  @doc false
  def start_link(%{graph: graph, initializer: initializer}) do
    GenServer.start_link(__MODULE__, graph, name: initializer)
  end

  @doc false
  def init(graph) do
    :ok =
      case Keyword.get(graph.config(), :init) do
        nil -> :ok
        {mod, fun} -> apply(mod, fun, [graph])
        {mod, fun, extra_args} -> apply(mod, fun, [graph | extra_args])
      end

    {:ok, graph}
  end
end
