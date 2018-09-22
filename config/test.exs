use Mix.Config

config :caylir, Caylir.TestHelpers.Graphs.DefaultGraph,
  host: "localhost",
  port: 64210

config :caylir, Caylir.TestHelpers.Graphs.EnvGraph,
  host: {:system, "CAYLIR_TEST_ENV_HOST"},
  port: {:system, "CAYLIR_TEST_ENV_PORT"}

# port will be properly set during test setup
config :caylir, Caylir.TestHelpers.Graphs.InetsGraph,
  host: "localhost",
  port: 9999

config :caylir, Caylir.TestHelpers.Graphs.LimitGraph,
  host: "localhost",
  limit: 1,
  port: 64210
