defmodule Caylir.Graph.URL do
  @moduledoc false

  @doc """
  Returns the URL for deleting quads.

  ## Example

      iex> delete([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/delete"
  """
  @spec delete(Keyword.t()) :: String.t()
  def delete(config), do: url("delete", config)

  @doc """
  Returns the URL to query the graph.

  ## Example

      iex> query([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/query/gizmo"

      iex> query([ host: "localhost", port: 64210, language: :gizmo ])
      "http://localhost:64210/api/v1/query/gizmo"

      iex> query([ host: "localhost", port: 64210, language: :gizmo, limit: 3 ])
      "http://localhost:64210/api/v1/query/gizmo?limit=3"

      iex> query([ host: "localhost", port: 64210, language: :graphql, limit: 3 ])
      "http://localhost:64210/api/v1/query/graphql?limit=3"
  """
  @spec query(Keyword.t()) :: String.t()
  def query(config), do: url_with_language("query", config) <> query_limit(config[:limit])

  @doc """
  Returns the URL to get the shape of a query.

  ## Example

      iex> shape([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/shape/gizmo"

      iex> shape([ host: "localhost", port: 64210, language: :gizmo ])
      "http://localhost:64210/api/v1/shape/gizmo"

      iex> shape([ host: "localhost", port: 64210, language: :graphql ])
      "http://localhost:64210/api/v1/shape/graphql"
  """
  @spec shape(Keyword.t()) :: String.t()
  def shape(config), do: url_with_language("shape", config)

  @doc """
  Returns the URL for writing quads.

  ## Example

      iex> write([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/write"
  """
  @spec write(Keyword.t()) :: String.t()
  def write(config), do: url("write", config)

  defp url(action, config) do
    "http://#{config[:host]}:#{config[:port]}/api/v1/#{action}"
  end

  defp url_with_language(action, config) do
    url(action, config) <> "/" <> query_language(config[:language])
  end

  defp query_language(nil), do: "gizmo"
  defp query_language(language), do: to_string(language)

  defp query_limit(nil), do: ""
  defp query_limit(limit), do: "?limit=#{limit}"
end
