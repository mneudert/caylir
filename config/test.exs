use Mix.Config

config :caylir, Caylir.TestHelpers.Graphs.DefaultGraph,
  host: "localhost",
  pool: [max_overflow: 0, size: 1],
  port: 64210

config :caylir, Caylir.TestHelpers.Graphs.EnvGraph,
  host: {:system, "CAYLIR_TEST_ENV_HOST"},
  pool: [max_overflow: 0, size: 1],
  port: {:system, "CAYLIR_TEST_ENV_PORT"}

# port will be properly set during test setup
config :caylir, Caylir.TestHelpers.Graphs.InetsGraph,
  host: "localhost",
  pool: [max_overflow: 0, size: 1],
  port: 9999

config :caylir, Caylir.TestHelpers.Graphs.LimitGraph,
  host: "localhost",
  limit: 1,
  pool: [max_overflow: 0, size: 1],
  port: 64210
