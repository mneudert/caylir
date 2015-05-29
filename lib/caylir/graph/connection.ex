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

  @doc """
  Proxy implementation for `Caylir.Graph.delete/1`.
  """
  @spec delete(module, Keyword.t) :: Caylir.Graph.t_delete
  def delete(graph, quad) do
    GenServer.call(graph, { :delete, quad })
  end

  @doc """
  Proxy implementation for `Caylir.Graph.query/1`.
  """
  @spec query(module, String.t) :: Caylir.Graph.t_query
  def query(graph, query) do
    GenServer.call(graph, { :query, query })
  end

  @doc """
  Proxy implementation for `Caylir.Graph.write/1`.
  """
  @spec write(module, Keyword.t) :: Caylir.Graph.t_write
  def write(graph, quad) do
    GenServer.call(graph, { :write, quad })
  end
end
