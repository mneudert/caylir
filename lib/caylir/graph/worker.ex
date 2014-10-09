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
    url          = Graph.URL.delete(graph) |> :binary.bin_to_list()
    content_type = 'application/x-www-form-urlencoded'
    body         = [ quad ] |> Poison.encode!
    headers      = [{ 'Content-Length', byte_size(body) }]
    body         = body |> :binary.bin_to_list()

    request  = { url, headers, content_type, body }
    response = :httpc.request(:post, request, [], [])

    case Graph.Response.parse(response) do
      { :ok, 200, _success }          -> { :reply, :ok, graph }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, graph }
      { :error, reason }              -> { :reply, { :error, reason }, graph }
      parsed                          -> raise "Invalid response: #{ inspect parsed }"
    end
  end

  def handle_call({ :write, quad }, _from, graph) do
    url          = Graph.URL.write(graph) |> :binary.bin_to_list()
    content_type = 'application/x-www-form-urlencoded'
    body         = [ quad ] |> Poison.encode!
    headers      = [{ 'Content-Length', byte_size(body) }]
    body         = body |> :binary.bin_to_list()

    request  = { url, headers, content_type, body }
    response = :httpc.request(:post, request, [], [])

    case Graph.Response.parse(response) do
      { :ok, 200, _success }          -> { :reply, :ok, graph }
      { :ok, 400, %{ error: reason }} -> { :reply, { :error, reason }, graph }
      { :error, reason }              -> { :reply, { :error, reason }, graph }
      parsed                          -> raise "Invalid response: #{ inspect parsed }"
    end
  end
end
