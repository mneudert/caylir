defmodule Caylir.Graph.Request do
  @moduledoc """
  Sends requests to the server.
  """

  alias Caylir.Graph

  @doc """
  Deletes a quad from the graph.
  """
  @spec delete(map | [map], Keyword.t) :: Graph.t_delete
  def delete(quad,  conn) when is_map(quad), do: delete([ quad ], conn)
  def delete(quads, conn) do
    url  = Graph.URL.delete(conn)
    body = Poison.encode!(quads)

    case send(:post, url, body) do
      { :ok, _,   %{ error: reason }} -> { :error, reason }
      { :ok, 200, _success }          -> :ok
    end
  end

  @doc """
  Queries the graph.
  """
  @spec query(String.t, Keyword.t) :: Graph.t_query
  def query(query, conn) do
    url = Graph.URL.query(conn)

    case send(:post, url, query) do
      { :ok, _,   %{ error:  reason }} -> { :error, reason }
      { :ok, 200, %{ result: result }} -> result
    end
  end


  @doc """
  Gets the shape of a query.
  """
  @spec shape(String.t, Keyword.t) :: Graph.t_query
  def shape(query, conn) do
    url = Graph.URL.shape(conn)

    case send(:post, url, query) do
      { :ok, _,   %{ error: reason }} -> { :error, reason }
      { :ok, 200, shape }             -> shape
    end
  end

  @doc """
  Writes a quad to the graph.
  """
  @spec write(map | [map], Keyword.t) :: Graph.t_write
  def write(quad,  conn) when is_map(quad), do: write([ quad ], conn)
  def write(quads, conn) do
    url  = Graph.URL.write(conn)
    body = Poison.encode!(quads)

    case send(:post, url, body) do
      { :ok, _,   %{ error: reason }} -> { :error, reason }
      { :ok, 200, _content }          -> :ok
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
