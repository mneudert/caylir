defmodule Caylir.Graph.Config do
  @moduledoc """
  ## Query Language Configuration

  By default all queries are expected to use the Gizmo query language.

  Using the configuration key `:language` you can switch the default
  language endpoint to use:

      config :my_app, MyGraph,
        language: :graphql

  The HTTP URLs used to send the queries (for both `:query` and `:shape` calls)
  are constructed as `/api/v1/\#{call}/\#{language}`. Depending on your
  choice and used Cayley version the `:shape` endpoint might not be available.

  ## Query Limit Configuration

  You can define a default query limit by adding it to your graph config:

      config :my_app, MyGraph,
        limit: -1

  ## JSON Decoder/Encoder Configuration

  By default the library used for encoding/decoding JSON is `:jason`.
  For the time `:caylir` directly depends on it to ensure it is available.

  If you want to use another library you can switch it:

  ```elixir
  config :my_app, MyGraph,
    json_decoder: MyJSONLibrary,
    json_encoder: MyJSONLibrary

  config :my_app, MyGraph,
    json_decoder: {MyJSONLibrary, :decoder_argless},
    json_encoder: {MyJSONLibrary, :encoder_argless}

  config :my_app, MyGraph,
    json_decoder: {MyJSONLibrary, :decode_it, [[keys: :atoms]]},
    json_encoder: {MyJSONLibrary, :encode_it, []}
  ```

  If you configure only a module name it will be called
  as `module.decode!(binary)` and `module.encode!(map)`. When using
  a more complete `{m, f}` or `{m, f, args}` configuration the data
  to decode/encode will passed as the first argument with your
  configured extra arguments following.
  """

  @doc """
  Retrieves the graph configuration for `graph` in `otp_app`.
  """
  @spec config(atom, module, defaults :: Keyword.t()) :: Keyword.t()
  def config(nil, _, defaults), do: defaults

  def config(otp_app, graph, defaults) do
    defaults
    |> Keyword.merge(Application.get_env(otp_app, graph, []))
    |> Keyword.put(:otp_app, otp_app)
  end
end
