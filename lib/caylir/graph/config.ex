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
    |> maybe_fetch_system()
  end

  defp log_system_config_deprecation() do
    Logger.info(
      "Accessing the system environment for configuration via" <>
        " {:system, \"var\"} has been deprecated. Please switch" <>
        " to an initializer function to avoid future problems."
    )
  end

  defp maybe_fetch_system(config) when is_list(config) do
    Enum.map(config, fn
      {k, v} -> {k, maybe_fetch_system(v)}
      other -> other
    end)
  end

  defp maybe_fetch_system({:system, var, default}) do
    log_system_config_deprecation()

    System.get_env(var) || default
  end

  defp maybe_fetch_system({:system, var}) do
    log_system_config_deprecation()
    System.get_env(var)
  end

  defp maybe_fetch_system(config), do: config

  defp validate!([otp_app: _], graph) do
    # single key match only possible if both
    # - empty environment config
    # - missing inline defaults
    raise ArgumentError, "graph #{inspect(graph)} has no usable configuration"
  end

  defp validate!(config, _), do: config
end
