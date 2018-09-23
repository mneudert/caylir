defmodule Caylir.TestHelpers.Graphs.EnvGraph do
  use Caylir.Graph,
    otp_app: :caylir,
    config: [
      host: {:system, "CAYLIR_TEST_ENV_HOST"},
      port: {:system, "CAYLIR_TEST_ENV_PORT"}
    ]
end
