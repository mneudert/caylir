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

  def handle_call({:delete, quad, opts}, _from, state) do
    {:reply, Request.delete(quad, opts, state), state}
  end

  def handle_call({:query, query, opts}, _from, state) do
    {:reply, Request.query(query, opts, state), state}
  end

  def handle_call({:shape, query, opts}, _from, state) do
    {:reply, Request.shape(query, opts, state), state}
  end

  def handle_call({:write, quad, opts}, _from, state) do
    {:reply, Request.write(quad, opts, state), state}
  end
end
