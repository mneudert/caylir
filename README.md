# Caylir

Cayley driver for Elixir

__Note__: If you are reading this on [GitHub](https://github.com/mneudert/caylir) then the information in this file may be out of sync with the [Hex package](https://hex.pm/packages/caylir). If you are using this library through Hex please refer to the appropriate documentation on [HexDocs](https://hexdocs.pm/caylir).

## Cayley Support

Tested Cayley versions:

- `0.7.3`
- `0.7.4`
- `0.7.5`
- `0.7.7`

(see [`.travis.yml`](https://github.com/mneudert/caylir/blob/master/.travis.yml) to be sure)

## Package Setup

To use Caylir with your projects, edit your `mix.exs` file and add the required dependencies:

```elixir
defp deps do
  [
    # ...
    {:caylir, "~> 0.11"},
    # ...
  ]
end
```

## Application Setup

### Graph Definition

Defining a graph connection requires defining a module:

```elixir
defmodule MyApp.MyGraph do
  use Caylir.Graph, otp_app: :my_app
end
```

The `:otp_app` name and the name of the module can be freely chosen but have to be linked to a corresponding configuration entry. This defined graph module needs to be hooked up into your supervision tree:

```elixir
children = [
  # ...
  MyApp.MyGraph,
  # ...
]
```

### Configuration (static)

The most simple way is to use a completely static configuration:

```elixir
config :my_app, MyApp.MyGraph,
  host: "cayley.host",
  port: 42160,
  scheme: "https"
```

Default values for missing configuration keys:

```elixir
config :my_app, MyApp.MyGraph,
  host: "localhost",
  port: 64210,
  scheme: "http"
```

### Configuration (dynamic)

If you cannot, for whatever reason, use a static application config you can configure an initializer module that will be called every time your graph is started (or restarted) in your supervision tree:

```elixir
# {mod, fun}
config :my_app, MyApp.MyGraph,
  init: {MyInitModule, :my_init_mf}

# {mod, fun, args}
config :my_app, MyApp.MyGraph,
  init: {MyInitModule, :my_init_mfa, [:foo, :bar]}

defmodule MyInitModule do
  @spec my_init_mf(module) :: :ok
  def my_init_mf(graph), do: my_init_mfa(graph, :foo, :bar)

  @spec my_init_mfa(module, atom, atom) :: :ok
  def my_init_mfa(graph, :foo, :bar) do
    config =
      Keyword.merge(
        graph.config(),
        host: "localhost",
        port: 64210
      )

    Application.put_env(:my_app, graph, config)
  end
end
```

When the graph is started the function will be called with the graph module as the first parameter with optional `{m, f, a}` parameters from your configuration following. This will be done before the graph is available for use.

The function is expected to always return `:ok`.

### Configuration (inline defaults)

For some use cases (e.g. testing) it may be sufficient to define hardcoded configuration defaults outside of your application environment:

```elixir
defmodule MyApp.MyGraph do
  use Caylir.Graph,
    otp_app: :my_app,
    config: [
      host: "localhost",
      port: 64210
    ]
end
```

These values will be overwritten by and/or merged with the application environment values when the configuration is accessed.

## Usage

Writing Data:

```elixir
# single quad
MyApp.MyGraph.write(%{
  subject: "graph",
  predicate: "connection",
  object: "target"
})

# multiple quads (bulk write)
MyApp.MyGraph.write([quad_1, quad_2])
```

Querying data:

```elixir
# Gizmo syntax!
query = "graph.Vertex('graph').Out('connection').All()"

# Default result limit
MyApp.MyGraph.query(query)

# Custom result limit (limited + unlimited)
MyApp.MyGraph.query(query, limit: 3)
MyApp.MyGraph.query(query, limit: -1)
```

Deleting Data:

```elixir
# single quad
MyApp.MyGraph.delete(%{
  subject: "graph",
  predicate: "connection",
  object: "target"
})

# multiple quads (bulk delete)
MyApp.MyGraph.delete([quad_1, quad_2])
```

### JSON Configuration

By default the library used for encoding/decoding JSON is `:jason`. For the time `:caylir` directly depends on it to ensure it is available.

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

If you configure only a module name it will be called as `module.decode!(binary)` and `module.encode!(map)`. When using a more complete `{m, f}` or `{m, f, a}` configuration the data to decode/encode will passed as the first argument with your configured extra arguments following.

### Query Language Configuration

If you are using a query language other than the default `:gizmo` you can configure your graph to use a different endpoint:

```elixir
config :my_app, MyApp.MyGraph,
  language: :graphql
```

### Query Limit Configuration

You can define a default query limit by adding it to your graph config:

```elixir
config :my_app, MyApp.MyGraph,
  limit: -1
```

### Query Timeout Configuration

Using all default values and no specific parameters each query is allowed to take up to 5000 milliseconds (`GenServer.call/2` timeout) to complete. That may be too long or not long enough in some cases.

To change that timeout you can configure your graph:

```elixir
# lowering timeout to 500 ms
config :my_app, MyApp.MyGraph,
  query_timeout: 500
```

or pass an individual timeout for a single query:

```elixir
MyApp.MyGraph.query(query, timeout: 250)
```

A passed or graph wide timeout configuration override any `:recv_timeout` of your `:hackney` (HTTP client) configuration.

This does not apply to write requests. They are currently only affected by configured `:recv_timeout` values. Setting a graph timeout enables you to have a different timeout for read and write requests.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
