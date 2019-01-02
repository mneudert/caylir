defmodule Caylir.TestHelpers.Graphs.LimitGraph do
  @moduledoc false

  # credo:disable-for-lines:7 Credo.Check.Readability.LargeNumbers
  use Caylir.Graph,
    otp_app: :caylir,
    config: [
      host: "localhost",
      limit: 1,
      port: 64210
    ]
end
