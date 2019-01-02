defmodule Caylir.TestHelpers.Graphs.DefaultGraph do
  @moduledoc false

  # credo:disable-for-lines:6 Credo.Check.Readability.LargeNumbers
  use Caylir.Graph,
    otp_app: :caylir,
    config: [
      host: "localhost",
      port: 64210
    ]
end
