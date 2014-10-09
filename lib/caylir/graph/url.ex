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
