defmodule Caylir.Graph.ConfigTest do
  use ExUnit.Case, async: true

  alias Caylir.Graph.Config

  test "otp_app configuration", %{ test: test } do
    config = [ foo: :bar ]
    :ok    = Application.put_env(test, __MODULE__, config)

    assert ([ otp_app: test ] ++ config) == Config.config(test, __MODULE__)
  end

  test "missing configuration raises", %{ test: test } do
    exception = assert_raise ArgumentError, fn ->
      Config.config(test, __MODULE__)
    end

    assert String.contains?(exception.message, inspect __MODULE__)
    assert String.contains?(exception.message, inspect test)
  end

  test "runtime configuration changes" do
    conn = Module.concat([ __MODULE__, RuntimeChanges ])
    key  = :runtime_testing_key

    Application.put_env(:caylir, conn, [ foo: :bar ])

    defmodule conn do
      use Caylir.Graph, otp_app: :caylir
    end

    refute Keyword.has_key?(conn.config(), key)

    Application.put_env(:caylir, conn, Keyword.put(conn.config(), key, :exists))

    assert :exists == Keyword.get(conn.config(), key)
  end
end
