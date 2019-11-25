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
    |> convert_to_mfa(:decode!)
  end

  @doc """
  Returns the JSON encoder for a graph.
  """
  @spec encoder(Keyword.t()) :: {module, atom, [term]}
  def encoder(graph_config) do
    graph_config
    |> Keyword.get(:json_encoder, @default_encoder)
    |> convert_to_mfa(:encode!)
  end

  defp convert_to_mfa({_, _, _} = mfa, _), do: mfa
  defp convert_to_mfa({module, function}, _), do: {module, function, []}
  defp convert_to_mfa(module, function), do: {module, function, []}
end
