defmodule Caylir.Deprecations.SystemConfigTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  alias Caylir.TestHelpers.Graphs.EnvGraph

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

    log =
      capture_log(fn ->
        assert sys_val == conn.config()[key]
      end)

    System.delete_env(sys_var)

    assert log =~ ~r/deprecated/i
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

    log =
      capture_log(fn ->
        assert default == conn.config()[key]
      end)

    assert log =~ ~r/deprecated/i
  end

  test "system configuration connection" do
    log =
      capture_log(fn ->
        Supervisor.start_link([EnvGraph], strategy: :one_for_one)

        assert nil == EnvGraph.config()[:host]

        System.put_env("CAYLIR_TEST_ENV_HOST", "localhost")
        System.put_env("CAYLIR_TEST_ENV_PORT", "64210")

        assert "localhost" == EnvGraph.config()[:host]
        assert ["meow"] == EnvGraph.query("graph.Emit('meow')")

        System.delete_env("CAYLIR_TEST_ENV_HOST")
        System.delete_env("CAYLIR_TEST_ENV_PORT")
      end)

    assert log =~ ~r/deprecated/i
  end
end
