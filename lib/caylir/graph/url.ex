defmodule Caylir.Graph.URL do
  @moduledoc """
  Utility module to generate the URLs for graph interaction.
  """

  @doc """
  Returns the URL for deleting quads.

  ## Example

      iex> delete([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/delete"
  """
  @spec delete(Keyword.t()) :: String.t()
  def delete(config), do: "#{base_url(config)}/delete"

  @doc """
  Returns the URL to query the graph.

  ## Example

      iex> query([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/query/gizmo"

      iex> query([ host: "localhost", port: 64210, language: :gizmo ])
      "http://localhost:64210/api/v1/query/gizmo"

      iex> query([ host: "localhost", port: 64210, language: :gremlin ])
      "http://localhost:64210/api/v1/query/gremlin"
  """
  @spec query(Keyword.t()) :: String.t()
  def query(config), do: "#{base_url(config)}/query/#{query_language(config[:language])}"

  @doc """
  Returns the URL to get the shape of a query.

  ## Example

      iex> shape([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/shape/gizmo"

      iex> shape([ host: "localhost", port: 64210, language: :gizmo ])
      "http://localhost:64210/api/v1/shape/gizmo"

      iex> shape([ host: "localhost", port: 64210, language: :gremlin ])
      "http://localhost:64210/api/v1/shape/gremlin"
  """
  @spec shape(Keyword.t()) :: String.t()
  def shape(config), do: "#{base_url(config)}/shape/#{query_language(config[:language])}"

  @doc """
  Returns the URL for writing quads.

  ## Example

      iex> write([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/write"
  """
  @spec write(Keyword.t()) :: String.t()
  def write(config), do: "#{base_url(config)}/write"

  defp base_url(config) do
    "http://#{config[:host]}:#{config[:port]}/api/v1"
  end

  defp query_language(:gizmo), do: "gizmo"
  defp query_language(:gremlin), do: "gremlin"
  defp query_language(nil), do: "gizmo"
end
