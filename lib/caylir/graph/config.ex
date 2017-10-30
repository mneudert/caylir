defmodule Caylir.Graph.Config do
  @moduledoc """
  Configuration helper module.
  """

  @doc """
  Retrieves the connection configuration for `conn` in `otp_app`.
  """
  @spec config(atom, module) :: Keyword.t()
  def config(otp_app, conn) do
    otp_app
    |> Application.get_env(conn, [])
    |> Keyword.put(:otp_app, otp_app)
    |> validate!(conn)
    |> maybe_fetch_system()
  end

  defp maybe_fetch_system(config) when is_list(config) do
    Enum.map(config, fn
      {k, v} -> {k, maybe_fetch_system(v)}
      other -> other
    end)
  end

  defp maybe_fetch_system({:system, var, default}) do
    System.get_env(var) || default
  end

  defp maybe_fetch_system({:system, var}), do: System.get_env(var)
  defp maybe_fetch_system(config), do: config

  defp validate!([otp_app: otp_app], conn) do
    # single key match only possible with empty environment
    raise ArgumentError,
          "configuration for #{inspect(conn)}" <>
            " not found in #{inspect(otp_app)} configuration"
  end

  defp validate!(config, _), do: config
end
