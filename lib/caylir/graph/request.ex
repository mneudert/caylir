defmodule Caylir.Graph.Request do
  @moduledoc false

  alias Caylir.Graph
  alias Caylir.Graph.JSON

  @doc """
  Deletes a quad from the graph.
  """
  @spec delete(map | [map], Keyword.t(), map) :: Graph.t_delete()
  def delete(quad, opts, state) when is_map(quad), do: delete([quad], opts, state)

  def delete(quads, opts, %{module: graph}) do
    config = graph.config()
    json_decoder = JSON.decoder(graph)
    json_encoder = JSON.encoder(graph)

    url = Graph.URL.delete(config)
    body = apply_mfa(json_encoder, quads)

    response =
      :post
      |> send(url, body, http_opts(config, opts))
      |> parse_response(json_decoder)

    case response do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, _, %{"error" => reason}} -> {:error, reason}
      {:ok, 200, _success} -> :ok
    end
  end

  @doc """
  Queries the graph.
  """
  @spec query(String.t(), Keyword.t(), map) :: Graph.t_query()
  def query(query, opts, %{module: graph}) do
    config = graph.config()
    json_decoder = JSON.decoder(graph)

    url =
      config
      |> Keyword.merge(opts)
      |> Graph.URL.query()

    response =
      :post
      |> send(url, query, http_opts(config, opts))
      |> parse_response(json_decoder)

    case response do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, _, %{"error" => reason}} -> {:error, reason}
      {:ok, 200, %{result: result}} -> result
      {:ok, 200, %{"result" => result}} -> result
    end
  end

  @doc """
  Gets the shape of a query.
  """
  @spec shape(String.t(), Keyword.t(), map) :: Graph.t_query()
  def shape(query, opts, %{module: graph}) do
    config = graph.config()
    json_decoder = JSON.decoder(graph)

    url = Graph.URL.shape(config)

    response =
      :post
      |> send(url, query, http_opts(config, opts))
      |> parse_response(json_decoder)

    case response do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, _, %{"error" => reason}} -> {:error, reason}
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
    json_decoder = JSON.decoder(graph)
    json_encoder = JSON.encoder(graph)

    url = Graph.URL.write(config)
    body = apply_mfa(json_encoder, quads)

    response =
      :post
      |> send(url, body, http_opts(config, opts))
      |> parse_response(json_decoder)

    case response do
      {:ok, _, %{error: reason}} -> {:error, reason}
      {:ok, _, %{"error" => reason}} -> {:error, reason}
      {:ok, 200, _content} -> :ok
    end
  end

  # Utility methods

  defp apply_mfa({mod, fun, extra_args}, main_arg) do
    apply(mod, fun, [main_arg | extra_args])
  end

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

  defp parse_response({:ok, status, body}, parser) when is_binary(body) do
    {:ok, status, apply_mfa(parser, body)}
  end

  defp parse_response(response, _), do: response

  defp send(method, url, payload, http_opts) do
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    response = :hackney.request(method, url, headers, payload, http_opts)

    case response do
      {:error, reason} ->
        {:ok, nil, %{error: reason}}

      {:ok, status, _headers, client} ->
        {:ok, response_body} = :hackney.body(client)

        {:ok, status, response_body}
    end
  end
end
