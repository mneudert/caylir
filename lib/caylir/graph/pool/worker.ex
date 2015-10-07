defmodule Caylir.Graph.Pool.Worker do
  @moduledoc """
  Pool worker.
  """

  use GenServer

  alias Caylir.Graph.Request

  @behaviour :poolboy_worker

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn)
  end

  def init(conn), do: { :ok, conn }


  # GenServer callbacks

  def handle_call({ :delete, quad }, _from, conn) do
    { :reply, Request.delete(quad, conn), conn }
  end

  def handle_call({ :query, query }, _from, conn) do
    { :reply, Request.query(query, conn), conn }
  end

  def handle_call({ :shape, query }, _from, conn) do
    { :reply, Request.shape(query, conn), conn }
  end

  def handle_call({ :write, quad }, _from, conn) do
    { :reply, Request.write(quad, conn), conn }
  end
end
