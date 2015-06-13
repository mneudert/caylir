Code.require_file("helpers/graph.exs", __DIR__)


Supervisor.start_link(
  [ Caylir.TestHelpers.Graph.child_spec ],
  strategy: :one_for_one
)


ExUnit.start()
