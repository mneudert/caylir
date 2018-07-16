# Caylir

Cayley driver for Elixir

## Warning

__This module is experimental at the moment and may behave or change unexpectedly.__

Tested cayley versions:

- `0.6.1`
- `0.7.0`
- `0.7.1`
- `0.7.2`
- `0.7.3`
- `0.7.4`

(see
[`.travis.yml`](https://github.com/mneudert/caylir/blob/master/.travis.yml)
to be sure)

## Package Setup

Add caylir as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [
    # ...
    {:caylir, "~> 0.6"},
    # ...
  ]
end
```

You should also update your applications to include all necessary projects:

```elixir
def application do
  [
    applications: [
      # ...
      :caylir,
      # ...
    ]
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

The `:otp_app` name and the name of the module can be freely chosen but have to
be linked to a corresponding configuration entry. This defined graph module
needs to be hooked up into your supervision tree:

```elixir
children = [
  # ...

  # elixir < 1.5.0
  MyApp.MyGraph.child_spec(),
  # elixir >= 1.5.0
  MyApp.MyGraph,

  # ...
]
```

### Configuration (static)

The most simple way is to use a completely static configuration:

```elixir
config :my_app, MyApp.MyGraph,
  host: "localhost",
  pool: [max_overflow: 10, size: 50],
  port: 64210
```

### Configuration (dynamic)

If you cannot, for whatever reason, use a static application config you can
configure an initializer module that will be called every time your graph
is started (or restarted) in your supervision tree:

```elixir
config :my_app, MyApp.MyGraph,
  init: {MyInitModule, :my_init_fun}

defmodule MyInitModule do
  @spec my_init_fun(module) :: :ok
  def my_init_fun(graph) do
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

When the graph is started the function will be called with the graph module
as the first (and only) parameter. This will be done before the graph is
available for use.

The function is expected to always return `:ok`.

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

### Query Language Configuration

If you are using a cayley version prior to `0.7.0` (e.g. `0.6.1`) you may need
to change the default query language used:

```elixir
# default (suitable for cayley >= 0.7.0)
config :my_app, MyApp.MyGraph,
  language: :gizmo

# old query language used in 0.6.1
config :my_app, MyApp.MyGraph,
  language: :gremlin
```

### Query Limit Configuration

You can define a default query limit by adding it to your graph config:

```elixir
config :my_app, MyApp.MyGraph,
  limit: -1
```

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
