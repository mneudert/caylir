defmodule Caylir.Graph.Supervisor do
  @moduledoc """
  Graph Supervisor.
  """

  use Supervisor

  alias Caylir.Graph.Pool

  @doc false
  def start_link(graph) do
    opts = [name: Module.concat(graph, Supervisor)]

    Supervisor.start_link(__MODULE__, graph, opts)
  end

  @doc false
  def init(graph) do
    :ok =
      case Keyword.get(graph.config(), :init) do
        nil -> :ok
        {mod, fun} -> apply(mod, fun, [graph])
        {mod, fun, extra_args} -> apply(mod, fun, [graph | extra_args])
      end

    supervise([Pool.Spec.spec(graph)], strategy: :one_for_one)
  end
end
