defmodule Caylir.Graph.JSON do
  @moduledoc false

  @doc """
  Returns the JSON decoder for a graph.
  """
  @spec decoder(module) :: module
  def decoder(graph) do
    Keyword.get(graph.config(), :json_decoder, Poison)
  end

  @doc """
  Returns the JSON encoder for a graph.
  """
  @spec encoder(module) :: module
  def encoder(graph) do
    Keyword.get(graph.config(), :json_decoder, Poison)
  end
end
