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
    GenServer.start_link(__MODULE__, graph.config, name: graph)
  end

  @doc """
  Initializes the worker.
  """
  @spec init(Keyword.t) :: { :ok, Keyword.t }
  def init(conn), do: { :ok, conn }


  # GenServer Callbacks

  def handle_call({ :delete, quad }, _from, conn) do
    url      = Graph.URL.delete(conn)
    body     = [ quad ] |> Poison.encode!
    response = Graph.Request.send({ :post, url, body })

    case response do
      { :ok, 200, _success }          -> { :reply, :ok, conn }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, conn }
    end
  end

  def handle_call({ :query, query }, _from, conn) do
    url      = Graph.URL.query(conn)
    response = Graph.Request.send({ :post, url, query })

    case response do
      { :ok, 200, %{ result: result }} -> { :reply, result, conn }
      { :ok, 400, %{ error:  reason }} -> { :reply, { :error, reason }, conn }
    end
  end

    def handle_call({ :shape, query }, _from, conn) do
    url      = Graph.URL.shape(conn)
    response = Graph.Request.send({ :post, url, query })

    case response do
      { :ok, 200, shape }             -> { :reply, shape, conn }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, conn }
    end
  end

  def handle_call({ :write, quad }, _from, conn) do
    url      = Graph.URL.write(conn)
    body     = [ quad ] |> Poison.encode!
    response = Graph.Request.send({ :post, url, body })

    case response do
      { :ok, 200, _success }          -> { :reply, :ok, conn }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, conn }
    end
  end
end
