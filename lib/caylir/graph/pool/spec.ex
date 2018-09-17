defmodule Caylir.Graph.Pool.Spec do
  @moduledoc false

  alias Caylir.Graph.Pool

  @doc """
  Returns a supervisable pool child_spec.
  """
  @spec spec(module) :: Supervisor.Spec.spec()
  def spec(conn) do
    {pool_opts, worker_opts} = get_opts(conn)

    :poolboy.child_spec(conn, pool_opts, worker_opts)
  end

  defp get_opts(conn) do
    {pool_opts, _} = Keyword.split(conn.config, [:size, :max_overflow])

    pool_opts =
      pool_opts
      |> Keyword.put_new(:max_overflow, 10)
      |> Keyword.put_new(:size, 5)

    pool_opts =
      pool_opts
      |> Keyword.put(:name, {:local, conn.__pool__})
      |> Keyword.put(:worker_module, Pool.Worker)

    {pool_opts, %{module: conn}}
  end
end
