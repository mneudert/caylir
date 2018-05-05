# Caylir

Cayley driver for Elixir


## Warning

__This module is highly experimental at the moment and may behave or change unexpectedly.__

Tested cayley versions:

- `0.6.1`
- `0.7.0`
- `0.7.1`
- `0.7.2`
- `0.7.3`

(see
[`.travis.yml`](https://github.com/mneudert/caylir/blob/master/.travis.yml)
to be sure)


## Package Setup

Add caylir as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [
    # ...
    {:caylir, "~> 0.6"}
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
      :caylir
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
Supervisor.start_link(
  [
    # ...
    # elixir < 1.5.0
    MyApp.MyGraph.child_spec,
    # elixir >= 1.5.0
    MyApp.MyGraph,
    # ...
  ],
  strategy: :one_for_one
)
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
config :my_app, MyApp.MyGraph
  init: {MyInitModule, :my_init_fun}
```

Upon starting the function will be called with the graph module as the first
(and only) parameter. The function is expected to always return `:ok`.

### Configuration (system environment)

A third way is to grab values from your system environment directly:

```elixir
config :my_app, MyApp.MyGraph,
  port: {:system, "MY_ENV_VARIABLE"}

# additional default will only be used if environment variable is UNSET
config :my_app, MyApp.MyGraph
  port: {:system, "MY_ENV_VARIABLE", "64210"}
```


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
MyApp.MyGraph.write([ quad_1, quad_2 ])
```

Querying data:

```elixir
# Gizmo syntax!
MyApp.MyGraph.query("graph.Vertex('graph').Out('connection').All()")
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


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
