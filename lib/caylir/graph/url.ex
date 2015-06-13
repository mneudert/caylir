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
  def delete(conn), do: "#{ base_url conn }/delete"

  @doc """
  Returns the URL to query the graph.

  ## Example

      iex> query([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/query/gremlin"
  """
  @spec query(Keyword.t) :: String.t
  def query(conn), do: "#{ base_url conn }/query/gremlin"

  @doc """
  Returns the URL to get the shape of a query.

  ## Example

      iex> shape([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/shape/gremlin"
  """
  @spec shape(Keyword.t) :: String.t
  def shape(conn), do: "#{ base_url conn }/shape/gremlin"

  @doc """
  Returns the URL for writing quads.

  ## Example

      iex> write([ host: "localhost", port: 64210 ])
      "http://localhost:64210/api/v1/write"
  """
  @spec write(Keyword.t) :: String.t
  def write(conn), do: "#{ base_url conn }/write"


  defp base_url(conn) do
    "http://#{ conn[:host] }:#{ conn[:port] }/api/v1"
  end
end
