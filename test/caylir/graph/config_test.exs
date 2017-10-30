defmodule Caylir.Graph.ConfigTest do
  use ExUnit.Case, async: true

  alias Caylir.Graph.Config
  alias Caylir.TestHelpers.Graphs.EnvGraph

  test "otp_app configuration", %{test: test} do
    config = [foo: :bar]
    :ok = Application.put_env(test, __MODULE__, config)

    assert [otp_app: test] ++ config == Config.config(test, __MODULE__)
  end

  test "missing configuration raises", %{test: test} do
    exception =
      assert_raise ArgumentError, fn ->
        Config.config(test, __MODULE__)
      end

    assert String.contains?(exception.message, inspect(__MODULE__))
    assert String.contains?(exception.message, inspect(test))
  end

  test "runtime configuration changes" do
    conn = Module.concat([__MODULE__, RuntimeChanges])
    key = :runtime_testing_key

    Application.put_env(:caylir, conn, foo: :bar)

    defmodule conn do
      use Caylir.Graph, otp_app: :caylir
    end

    refute Keyword.has_key?(conn.config(), key)

    Application.put_env(:caylir, conn, Keyword.put(conn.config(), key, :exists))

    assert :exists == Keyword.get(conn.config(), key)
  end

  test "system configuration access" do
    conn = Module.concat([__MODULE__, SystemConfiguration])
    key = :system_testing_key
    sys_val = "fetch from system environment"
    sys_var = "CAYLIR_TEST_CONFIG"

    System.put_env(sys_var, sys_val)
    Application.put_env(:caylir, conn, [{key, {:system, sys_var}}])

    defmodule conn do
      use Caylir.Graph, otp_app: :caylir
    end

    assert sys_val == conn.config()[key]

    System.delete_env(sys_var)
  end

  test "system configuration access (with default)" do
    conn = Module.concat([__MODULE__, SystemConfigurationDefault])
    key = :system_testing_key
    default = "fetch from system environment"
    sys_var = "CAYLIR_TEST_CONFIG_DEFAULT"

    System.delete_env(sys_var)
    Application.put_env(:caylir, conn, [{key, {:system, sys_var, default}}])

    defmodule conn do
      use Caylir.Graph, otp_app: :caylir
    end

    assert default == conn.config()[key]
  end

  test "system configuration connection" do
    assert nil == EnvGraph.config()[:host]

    System.put_env("CAYLIR_TEST_ENV_HOST", "localhost")
    System.put_env("CAYLIR_TEST_ENV_PORT", "64210")

    assert "localhost" == EnvGraph.config()[:host]
    assert ["meow"] == EnvGraph.query("graph.Emit('meow')")

    System.delete_env("CAYLIR_TEST_ENV_HOST")
    System.delete_env("CAYLIR_TEST_ENV_PORT")
  end
end
