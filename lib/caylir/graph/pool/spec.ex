defmodule Caylir.Graph.Pool.Spec do
  @moduledoc false

  alias Caylir.Graph.Pool.Worker

  @doc """
  Returns a supervisable pool child_spec.
  """
  @spec spec(module) :: Supervisor.Spec.spec()
  def spec(graph) do
    pool_name = Module.concat(graph, Pool)

    pool_opts =
      graph.config()
      |> Keyword.take([:size, :max_overflow])
      |> Keyword.put(:name, {:local, pool_name})
      |> Keyword.put(:worker_module, Worker)

    :poolboy.child_spec(graph, pool_opts, %{module: graph})
  end
end
