alias Caylir.TestHelpers

Supervisor.start_link(
  [ TestHelpers.Graph.child_spec ],
  strategy: :one_for_one
)


ExUnit.start()
