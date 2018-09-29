defmodule Caylir.Graph.Request do
  @moduledoc false

  alias Caylir.Graph

  @doc """
  Deletes a quad from the graph.
  """
  @spec delete(map | [map], Keyword.t(), map) :: Graph.t_delete()
  def delete(quad, opts, state) when is_map(quad), do: delete([quad], opts, state)

  def delete(quads, _opts, %{module: graph}) do
    url = Graph.URL.delete(graph.config())
    body = Poison.encode!(quads)

    case send(:post, url, body) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, _success} -> :ok
    end
  end

  @doc """
  Queries the graph.
  """
  @spec query(String.t(), Keyword.t(), map) :: Graph.t_query()
  def query(query, opts, %{module: graph}) do
    url =
      graph.config()
      |> Keyword.merge(opts)
      |> Graph.URL.query()

    case send(:post, url, query) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, %{result: result}} -> result
    end
  end

  @doc """
  Gets the shape of a query.
  """
  @spec shape(String.t(), Keyword.t(), map) :: Graph.t_query()
  def shape(query, _opts, %{module: graph}) do
    url = Graph.URL.shape(graph.config())

    case send(:post, url, query) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, shape} -> shape
    end
  end

  @doc """
  Writes a quad to the graph.
  """
  @spec write(map | [map], Keyword.t(), map) :: Graph.t_write()
  def write(quad, opts, state) when is_map(quad), do: write([quad], opts, state)

  def write(quads, _opts, %{module: graph}) do
    url = Graph.URL.write(graph.config())
    body = Poison.encode!(quads)

    case send(:post, url, body) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, _content} -> :ok
    end
  end

  # Utility methods

  defp send(method, url, payload) do
    body = payload |> :binary.bin_to_list()

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Content-Length", length(body)}
    ]

    {:ok, status, _, client} = :hackney.request(method, url, headers, body)
    {:ok, response} = :hackney.body(client)

    parse_response(status, response)
  end

  defp parse_response(status, ""), do: {:ok, status}

  defp parse_response(status, body) do
    {:ok, status, Poison.decode!(body, keys: :atoms)}
  end
end
