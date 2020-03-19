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
defmodule MyGraph do
  use Caylir.Graph, otp_app: :my_app
end
```

This defined graph module needs to be hooked up into your supervision tree:

```elixir
children = [
  # ...
  MyGraph,
  # ...
]
```

For a more detailed explanation of how to get started with a graph please consult the inline documentation of the `Caylir.Graph` module.

To configure your connection you can use the application environment:

```elixir
config :my_app, MyGraph,
  host: "cayley.host",
  port: 42160,
  scheme: "https"
```

The entry should match the chosen `:otp_app` and module name defined earlier.

## Usage

Querying data:

```elixir
MyGraph.query("graph.Vertex('graph').Out('connection').All()")
```

Writing Data:

```elixir
MyGraph.write(%{
  subject: "graph",
  predicate: "connection",
  object: "target"
})
```

Deleting Data:

```elixir
MyGraph.delete(%{
  subject: "graph",
  predicate: "connection",
  object: "target"
})
```

A more detailed usage documentation can be found inline at the `Caylir.Graph` module.

### Query Timeout Configuration

Using all default values and no specific parameters each query is allowed to take up to 5000 milliseconds (`GenServer.call/2` timeout) to complete. That may be too long or not long enough in some cases.

To change that timeout you can configure your graph:

```elixir
# lowering timeout to 500 ms
config :my_app, MyGraph,
  query_timeout: 500
```

or pass an individual timeout for a single query:

```elixir
MyGraph.query(query, timeout: 250)
```

A passed or graph wide timeout configuration override any `:recv_timeout` of your `:hackney` (HTTP client) configuration.

This does not apply to write requests. They are currently only affected by configured `:recv_timeout` values. Setting a graph timeout enables you to have a different timeout for read and write requests.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
