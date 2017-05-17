defmodule Caylir.Graph.Request do
  @moduledoc """
  Sends requests to the server.
  """

  alias Caylir.Graph

  @doc """
  Deletes a quad from the graph.
  """
  @spec delete(map, Keyword.t) :: Graph.t_delete
  def delete(quad, conn) do
    url  = Graph.URL.delete(conn)
    body = [ quad ] |> Poison.encode!

    case send(:post, url, body) do
      { :ok, 200, _success }          -> :ok
      { :ok, 400, %{ error: reason }} -> { :error, reason }
    end
  end

  @doc """
  Queries the graph.
  """
  @spec query(String.t, Keyword.t) :: Graph.t_query
  def query(query, conn) do
    url = Graph.URL.query(conn)

    case send(:post, url, query) do
      { :ok, 200, %{ result: result }} -> result
      { :ok, 400, %{ error:  reason }} -> { :error, reason }
    end
  end


  @doc """
  Gets the shape of a query.
  """
  @spec shape(String.t, Keyword.t) :: Graph.t_query
  def shape(query, conn) do
    url = Graph.URL.shape(conn)

    case send(:post, url, query) do
      { :ok, 200, shape }             -> shape
      { :ok, 400, %{ error: reason }} -> { :error, reason }
    end
  end

  @doc """
  Writes a quad to the graph.
  """
  @spec write(map, Keyword.t) :: Graph.t_write
  def write(quad, conn) do
    url  = Graph.URL.write(conn)
    body = [ quad ] |> Poison.encode!

    case send(:post, url, body) do
      { :ok, 200, _success }          -> :ok
      { :ok, 400, %{ error: reason }} -> { :error, reason }
    end
  end


  # Utility methods

  defp send(method, url, payload) do
    body    = payload |> :binary.bin_to_list()
    headers = [{ "Content-Type",   "application/x-www-form-urlencoded" },
               { "Content-Length", length(body) }]

    { :ok, status, _, client } = :hackney.request(method, url, headers, body)
    { :ok, response }          = :hackney.body(client)

    parse_response(status, response)
  end

  defp parse_response(status, ""),  do: { :ok, status }
  defp parse_response(status, body) do
    { :ok, status, Poison.decode!(body, keys: :atoms) }
  end
end
