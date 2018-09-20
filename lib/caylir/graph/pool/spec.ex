defmodule Caylir.Graph.Pool.Spec do
  @moduledoc false

  alias Caylir.Graph.Pool

  @doc """
  Returns a supervisable pool child_spec.
  """
  @spec spec(module) :: Supervisor.Spec.spec()
  def spec(conn) do
    pool_opts =
      conn.config()
      |> Keyword.take([:size, :max_overflow])
      |> Keyword.put(:name, {:local, conn.__pool__()})
      |> Keyword.put(:worker_module, Pool.Worker)

    :poolboy.child_spec(conn, pool_opts, %{module: conn})
  end
end
