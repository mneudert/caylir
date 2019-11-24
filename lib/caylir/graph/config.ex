defmodule Caylir.Graph.Config do
  @moduledoc """
  Configuration helper module.
  """

  require Logger

  @doc """
  Retrieves the graph configuration for `graph` in `otp_app`.
  """
  @spec config(atom, module, defaults :: Keyword.t()) :: Keyword.t()
  def config(nil, _, defaults), do: defaults

  def config(otp_app, graph, defaults) do
    defaults
    |> Keyword.merge(Application.get_env(otp_app, graph, []))
    |> Keyword.put(:otp_app, otp_app)
  end
end
