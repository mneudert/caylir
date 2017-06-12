alias Caylir.TestHelpers
alias Caylir.TestHelpers.Undeprecate


# start fake server
root          = Undeprecate.to_charlist(__DIR__)
httpd_config  = [
  document_root: root,
  modules:       [:caylir_testhelpers_inets_proxy],
  port:          0,
  server_name:   'caylir_testhelpers_inets_proxy',
  server_root:   root
]

{ :ok, httpd_pid } = :inets.start(:httpd, httpd_config)

inets_env =
  :caylir
  |> Application.get_env(TestHelpers.InetsGraph)
  |> Keyword.put(:port, :httpd.info(httpd_pid)[:port])

Application.put_env(:caylir, TestHelpers.InetsGraph, inets_env)


# start graphs
Supervisor.start_link([
  TestHelpers.Graph.child_spec,
  TestHelpers.InetsGraph.child_spec
], strategy: :one_for_one)


# start ExUnit
ExUnit.start()
