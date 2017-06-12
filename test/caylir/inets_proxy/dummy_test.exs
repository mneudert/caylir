defmodule Caylir.InetsProxy.DummyTest do
  use ExUnit.Case, async: true

  alias Caylir.TestHelpers.InetsGraph


  test "dummy default response" do
    assert "dummy" == InetsGraph.query("")
  end
end
