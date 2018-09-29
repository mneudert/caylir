defmodule Caylir.InetsProxy.TimeoutTest do
  use ExUnit.Case, async: true

  alias Caylir.TestHelpers.Graphs.InetsGraph

  test "timeout" do
    timeout = 10

    opts = [
      language: "timeout",
      timeout: timeout
    ]

    assert {:error, :timeout} == InetsGraph.query("", opts)
  end

  test "timeout above GenServer defaults" do
    timeout = 7500

    opts = [
      language: "timeout_long",
      timeout: timeout
    ]

    assert {:error, :timeout} == InetsGraph.query("", opts)
  end
end
