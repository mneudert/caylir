use Mix.Config

config :caylir, Caylir.TestHelpers.Graph,
  host: "localhost",
  pool: [ max_overflow: 0, size: 1 ],
  port: 64210

config :caylir, Caylir.TestHelpers.InetsGraph,
  # port will be properly set during test setup
  host: "localhost",
  pool: [ max_overflow: 0, size: 1 ],
  port: 9999
