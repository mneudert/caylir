defmodule Caylir.Graph.Pool.Worker do
  @moduledoc """
  Pool worker.
  """

  alias Caylir.Graph.Request

  @behaviour :poolboy_worker

  @doc """
  Starts the worker process.
  """
  @spec start_link(conn :: Keyword.t) :: GenServer.on_start
  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn)
  end

  @doc """
  Initializes the worker.
  """
  @spec init(conn :: Keyword.t) :: { :ok, Keyword.t }
  def init(conn), do: { :ok, conn }


  # GenServer callbacks

  @doc false
  def handle_call({ :delete, quad }, _from, conn) do
    { :reply, Request.delete(quad, conn), conn }
  end

  @doc false
  def handle_call({ :query, query }, _from, conn) do
    { :reply, Request.query(query, conn), conn }
  end

  @doc false
  def handle_call({ :shape, query }, _from, conn) do
    { :reply, Request.shape(query, conn), conn }
  end

  @doc false
  def handle_call({ :write, quad }, _from, conn) do
    { :reply, Request.write(quad, conn), conn }
  end
end
