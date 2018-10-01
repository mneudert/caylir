defmodule Caylir.Graph.Config do
  @moduledoc """
  Configuration helper module.
  """

  require Logger

  @doc """
  Retrieves the graph configuration for `graph` in `otp_app`.
  """
  @spec config(atom, module, defaults :: Keyword.t()) :: Keyword.t()
  def config(otp_app, graph, defaults \\ []) do
    defaults
    |> Keyword.merge(Application.get_env(otp_app, graph, []))
    |> Keyword.put(:otp_app, otp_app)
    |> validate!(graph)
  end

  defp validate!([otp_app: _], graph) do
    # single key match only possible if both
    # - empty environment config
    # - missing inline defaults
    raise ArgumentError, "graph #{inspect(graph)} has no usable configuration"
  end

  defp validate!(config, _), do: config
end
