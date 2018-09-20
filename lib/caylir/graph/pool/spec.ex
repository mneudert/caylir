defmodule Caylir.Graph.Pool.Spec do
  @moduledoc false

  alias Caylir.Graph.Pool.Worker

  @doc """
  Returns a supervisable pool child_spec.
  """
  @spec spec(module) :: Supervisor.Spec.spec()
  def spec(conn) do
    pool_name = Module.concat(conn, Pool)

    pool_opts =
      conn.config()
      |> Keyword.take([:size, :max_overflow])
      |> Keyword.put(:name, {:local, pool_name})
      |> Keyword.put(:worker_module, Worker)

    :poolboy.child_spec(conn, pool_opts, %{module: conn})
  end
end
