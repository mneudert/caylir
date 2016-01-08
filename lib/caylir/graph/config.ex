defmodule Caylir.Graph.Config do
  @moduledoc """
  Configuration helper module.
  """

  @doc """
  Retrieves the connection configuration for `conn` in `otp_app`.
  """
  @spec config(atom, module) :: Keyword.t
  def config(otp_app, conn) do
    if config = Application.get_env(otp_app, conn) do
      [ otp_app: otp_app ] ++ config
    else
      raise ArgumentError, "configuration for #{ inspect conn }" <>
                           " not found in #{ inspect otp_app } configuration"
    end
  end
end
