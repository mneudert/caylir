defmodule Caylir.Graph.JSON do
  @moduledoc false

  @default_decoder {Jason, :decode!, [[keys: :atoms]]}
  @default_encoder {Jason, :encode!, []}

  @doc """
  Returns the JSON decoder for a graph.
  """
  @spec decoder(Keyword.t()) :: {module, atom, [term]}
  def decoder(graph_config) do
    graph_config
    |> Keyword.get(:json_decoder, @default_decoder)
    |> convert_to_mfargs(:decode!)
  end

  @doc """
  Returns the JSON encoder for a graph.
  """
  @spec encoder(Keyword.t()) :: {module, atom, [term]}
  def encoder(graph_config) do
    graph_config
    |> Keyword.get(:json_encoder, @default_encoder)
    |> convert_to_mfargs(:encode!)
  end

  defp convert_to_mfargs({_, _, _} = mfargs, _), do: mfargs
  defp convert_to_mfargs({module, function}, _), do: {module, function, []}
  defp convert_to_mfargs(module, function), do: {module, function, []}
end
