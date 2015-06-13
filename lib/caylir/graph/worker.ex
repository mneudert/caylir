defmodule Caylir.Graph.Worker do
  @moduledoc """
  Worker module for direct communication with the graph.
  """

  use GenServer

  alias Caylir.Graph

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
  def init(graph), do: { :ok, graph }


  # GenServer Callbacks

  def handle_call({ :delete, quad }, _from, graph) do
    url      = Graph.URL.delete(graph)
    body     = [ quad ] |> Poison.encode!
    response = Graph.Request.send({ :post, url, body })

    case response do
      { :ok, 200, _success }          -> { :reply, :ok, graph }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, graph }
    end
  end

  def handle_call({ :query, query }, _from, graph) do
    url      = Graph.URL.query(graph)
    response = Graph.Request.send({ :post, url, query })

    case response do
      { :ok, 200, %{ result: result }} -> { :reply, result, graph }
      { :ok, 400, %{ error:  reason }} -> { :reply, { :error, reason }, graph }
    end
  end

    def handle_call({ :shape, query }, _from, graph) do
    url      = Graph.URL.shape(graph)
    response = Graph.Request.send({ :post, url, query })

    case response do
      { :ok, 200, shape }             -> { :reply, shape, graph }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, graph }
    end
  end

  def handle_call({ :write, quad }, _from, graph) do
    url      = Graph.URL.write(graph)
    body     = [ quad ] |> Poison.encode!
    response = Graph.Request.send({ :post, url, body })

    case response do
      { :ok, 200, _success }          -> { :reply, :ok, graph }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, graph }
    end
  end
end
