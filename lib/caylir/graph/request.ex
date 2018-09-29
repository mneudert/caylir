defmodule Caylir.Graph.Request do
  @moduledoc false

  alias Caylir.Graph

  @doc """
  Deletes a quad from the graph.
  """
  @spec delete(map | [map], Keyword.t(), map) :: Graph.t_delete()
  def delete(quad, opts, state) when is_map(quad), do: delete([quad], opts, state)

  def delete(quads, opts, %{module: graph}) do
    config = graph.config()

    url = Graph.URL.delete(config)
    body = Poison.encode!(quads)

    case send(:post, url, body, http_opts(config, opts)) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, _success} -> :ok
    end
  end

  @doc """
  Queries the graph.
  """
  @spec query(String.t(), Keyword.t(), map) :: Graph.t_query()
  def query(query, opts, %{module: graph}) do
    config = graph.config()

    url =
      config
      |> Keyword.merge(opts)
      |> Graph.URL.query()

    case send(:post, url, query, http_opts(config, opts)) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, %{result: result}} -> result
    end
  end

  @doc """
  Gets the shape of a query.
  """
  @spec shape(String.t(), Keyword.t(), map) :: Graph.t_query()
  def shape(query, opts, %{module: graph}) do
    config = graph.config()
    url = Graph.URL.shape(config)

    case send(:post, url, query, http_opts(config, opts)) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, shape} -> shape
    end
  end

  @doc """
  Writes a quad to the graph.
  """
  @spec write(map | [map], Keyword.t(), map) :: Graph.t_write()
  def write(quad, opts, state) when is_map(quad), do: write([quad], opts, state)

  def write(quads, opts, %{module: graph}) do
    config = graph.config()

    url = Graph.URL.write(config)
    body = Poison.encode!(quads)

    case send(:post, url, body, http_opts(config, opts)) do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, 200, _content} -> :ok
    end
  end

  # Utility methods

  defp http_opts(config, opts) do
    call_opts = Keyword.get(opts, :http_opts, [])
    config_opts = Keyword.get(config, :http_opts, [])

    special_opts =
      case opts[:timeout] do
        nil -> []
        timeout -> [recv_timeout: timeout]
      end

    special_opts
    |> Keyword.merge(config_opts)
    |> Keyword.merge(call_opts)
  end

  defp send(method, url, payload, http_opts) do
    body = :binary.bin_to_list(payload)

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Content-Length", length(body)}
    ]

    response = :hackney.request(method, url, headers, body, http_opts)

    case response do
      {:error, reason} ->
        {:ok, nil, %{error: reason}}

      {:ok, status, _headers, client} ->
        {:ok, response} = :hackney.body(client)

        parse_response(status, response)
    end
  end

  defp parse_response(status, ""), do: {:ok, status}

  defp parse_response(status, body) do
    {:ok, status, Poison.decode!(body, keys: :atoms)}
  end
end
