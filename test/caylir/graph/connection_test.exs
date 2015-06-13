defmodule Caylir.Graph.ConnectionTest do
  use ExUnit.Case, async: true

  @otp_app    :caylir_connection_test
  @otp_config [ foo: :bar ]


  defmodule Conn do
    use Caylir.Graph, otp_app: :caylir_connection_test
  end


  setup_all do
    Application.put_env(@otp_app, Conn, @otp_config)
  end


  test "configuration" do
    config = [ otp_app: @otp_app ] ++ @otp_config

    assert config == Conn.config
  end

  test "child_spec" do
    assert { Conn, _, _, _, _, _ } = Conn.child_spec
  end
end
