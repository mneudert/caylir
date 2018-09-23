defmodule Caylir.TestHelpers.Graphs.LimitGraph do
  use Caylir.Graph,
    otp_app: :caylir,
    config: [
      host: "localhost",
      limit: 1,
      port: 64210
    ]
end
