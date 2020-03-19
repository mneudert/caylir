defmodule Caylir.Graph.Config do
  @moduledoc """
  ## How To Configure

  ### Inline Configuration

  For some use cases (e.g. testing) it may be sufficient to define hardcoded
  configuration defaults outside of your application environment:

      defmodule MyGraph do
        use Caylir.Graph,
          otp_app: :my_app,
          config: [
            host: "localhost",
            port: 64210
          ]
      end

  If you combine inline configuration with an `:otp_app` setting the inline
  defaults will be overwritten by and/or merged with the application
  environment values when the configuration is accessed.

  ### Dynamic Configuration

  If you cannot, or do not want to, use a static application config you can
  configure an initializer module that will be called every time your graph
  is started (or restarted) in your supervision tree:

      # {mod, fun}
      config :my_app, MyGraph,
        init: {MyInitModule, :my_init_mf}

      # {mod, fun, args}
      config :my_app, MyGraph,
        init: {MyInitModule, :my_init_mfargs, [:foo, :bar]}

      defmodule MyInitModule do
        @spec my_init_mf(module) :: :ok
        def my_init_mf(graph), do: my_init_mfargs(graph, :foo, :bar)

        @spec my_init_mfargs(module, atom, atom) :: :ok
        def my_init_mfargs(graph, :foo, :bar) do
          config =
            Keyword.merge(
              graph.config(),
              host: "localhost",
              port: 64210
            )

          Application.put_env(:my_app, graph, config)
        end
      end

  When the graph is started the function will be called with the graph module
  as the first parameter with optional `{m, f, args}` parameters from your
  configuration following. This will be done before the graph is available
  for use.

  The initializer function is expected to always return `:ok`.

  ## What To Configure

  Several configuration entries will be set to default values
  if they are not set manually:

      [
        host: "localhost",
        json_decoder: {Jason, :decode!, [[keys: :atoms]]},
        json_encoder: {Jason, :encode!, []},
        language: :gizmo,
        port: 64210,
        scheme: "http"
      ]

  ### Query Language Configuration

  By default all queries are expected to use the Gizmo query language.

  Using the configuration key `:language` you can switch the default
  language endpoint to use:

      config :my_app, MyGraph,
        language: :graphql

  The HTTP URLs used to send the queries (for both `:query` and `:shape` calls)
  are constructed as `/api/v1/\#{call}/\#{language}`. Depending on your
  choice and used Cayley version the `:shape` endpoint might not be available.

  ### Query Limit Configuration

  You can define a default query limit by adding it to your graph config:

      config :my_app, MyGraph,
        limit: -1

  ### JSON Decoder/Encoder Configuration

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
