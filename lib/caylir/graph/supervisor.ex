defmodule Caylir.Graph.Supervisor do
  @moduledoc """
  Graph Supervisor.
  """

  use Supervisor

  alias Caylir.Graph.Pool

  @doc """
  Starts the supervisor.
  """
  @spec start_link(atom) :: Supervisor.on_start()
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
      end

    supervise([Pool.Spec.spec(graph)], strategy: :one_for_one)
  end
end
