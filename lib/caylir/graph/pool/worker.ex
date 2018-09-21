defmodule Caylir.Graph.Pool.Worker do
  @moduledoc false

  use GenServer

  alias Caylir.Graph.Request

  @behaviour :poolboy_worker

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  # GenServer callbacks

  def handle_call({:delete, quad}, _from, state) do
    {:reply, Request.delete(quad, state), state}
  end

  def handle_call({:query, query, opts}, _from, state) do
    {:reply, Request.query(query, opts, state), state}
  end

  def handle_call({:shape, query}, _from, state) do
    {:reply, Request.shape(query, state), state}
  end

  def handle_call({:write, quad}, _from, state) do
    {:reply, Request.write(quad, state), state}
  end
end
