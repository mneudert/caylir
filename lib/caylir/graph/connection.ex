defmodule Caylir.Graph.Connection do
  @moduledoc """
  Module to handle the connection between a graph module and a graph worker.
  """

  @doc """
  Returns a child specification to start the connection using a supervisor.
  """
  @spec child_spec(module) :: Supervisor.Spec.spec
  def child_spec(graph) do
    import Supervisor.Spec

    worker(Caylir.Graph.Worker, [ graph ], id: graph)
  end
end
