defmodule Caylir.Graph.Worker do
  @moduledoc """
  Worker module for direct communication with the graph.
  """

  use GenServer

  @doc """
  Starts the worker process.
  """
  @spec start_link(module) :: GenServer.on_start
  def start_link(graph) do
    GenServer.start_link(__MODULE__, graph.conf, name: graph)
  end

  @doc """
  Initializes the worker.
  """
  @spec init(Keyword.t) :: { :ok, Keyword.t }
  def init(conn), do: { :ok, conn }
end
