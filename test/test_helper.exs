Supervisor.start_link(
  [ Caylir.TestHelpers.Graph.child_spec ],
  strategy: :one_for_one
)


ExUnit.start()
