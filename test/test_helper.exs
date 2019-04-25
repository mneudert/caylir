alias Caylir.TestHelpers.Graphs.InetsGraph

# start fake server
root = String.to_charlist(__DIR__)

httpd_config = [
  document_root: root,
  modules: [Caylir.TestHelpers.Inets.Handler],
  port: 0,
  server_name: 'caylir_testhelpers_inets_handler',
  server_root: root
]

{:ok, httpd_pid} = :inets.start(:httpd, httpd_config)

inets_env = [
  host: "localhost",
  port: :httpd.info(httpd_pid)[:port]
]

Application.put_env(:caylir, InetsGraph, inets_env)
Supervisor.start_link([InetsGraph], strategy: :one_for_one)

# start ExUnit
ExUnit.start()
