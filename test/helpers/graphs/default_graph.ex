defmodule Caylir.TestHelpers.Graphs.DefaultGraph do
  use Caylir.Graph,
    otp_app: :caylir,
    config: [
      host: "localhost",
      port: 64210
    ]
end
