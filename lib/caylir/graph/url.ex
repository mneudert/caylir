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
  @spec delete(Keyword.t) :: String.t
  def delete(graph), do: "#{ base_url graph }/delete"

  @doc """
  Returns the URL to query the graph.

  ## Example

      iex> query([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/query/gremlin"
  """
  @spec query(Keyword.t) :: String.t
  def query(graph), do: "#{ base_url graph }/query/gremlin"

  @doc """
  Returns the URL to get the shape of a query.

  ## Example

      iex> shape([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/shape/gremlin"
  """
  @spec shape(Keyword.t) :: String.t
  def shape(graph), do: "#{ base_url graph }/shape/gremlin"

  @doc """
  Returns the URL for writing quads.

  ## Example

      iex> write([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/write"
  """
  @spec write(Keyword.t) :: String.t
  def write(graph), do: "#{ base_url graph }/write"

  defp base_url([ host: host, port: port ]) do
    "http://#{ host }:#{ port }/api/v1"
  end
end
