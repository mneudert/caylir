defmodule Caylir.Graph.Supervisor do
  @moduledoc """
  Graph Supervisor.
  """

  use Supervisor

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
    supervise([graph.pool_spec], strategy: :one_for_one)
  end
end
