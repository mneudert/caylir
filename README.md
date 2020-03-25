# Caylir

Cayley driver for Elixir

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
    {:caylir, "~> 1.0"},
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

For more information on how (and what) to configure please refer to the inline documentation of the `Caylir.Graph.Config` module.

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

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
