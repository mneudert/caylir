Supervisor.start_link(
  [ CaylirTestHelpers.Graph.child_spec ],
  strategy: :one_for_one
)


ExUnit.start()
