# Caylir

Cayley driver for Elixir


## Warning

__This module is highly experimental at the moment and may behave or change unexpectedly.__

Tested cayley versions:

- `0.6.0`
- `0.6.1`

(see
[`.travis.yml`](https://github.com/mneudert/caylir/blob/v0.4.0/.travis.yml)
to be sure)


## Setup

Add Caylir as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [ { :caylir, "~> 0.4" } ]
end
```

You should also update your applications to include all necessary projects:

```elixir
def application do
  [ applications: [ :caylir ] ]
end
```


## Usage

### Graph Connections

Defining a graph connection requires defining a module:

```elixir
defmodule MyApp.MyGraph do
  use Caylir.Graph, otp_app: :my_app
end
```

The `:otp_app` name and the name of the module can be freely chosen.
They only need to be linked to an entry in your `config.exs`:

```elixir
config :my_app, MyApp.MyGraph,
  host: "localhost",
  pool: [ max_overflow: 0, size: 1 ],
  port: 64210
```

You now have a graph definition you can hook into your supervision tree:

```elixir
Supervisor.start_link(
  [ MyApp.MyGraph.child_spec ],
  strategy: :one_for_one
)
```

### Queries

Writing Data:

```elixir
# single quad
MyApp.MyGraph.write(%{
  subject:   "graph",
  predicate: "connection",
  object:    "target"
})

# multiple quads (bulk write)
MyApp.MyGraph.write([ quad_1, quad_2 ])
```

Querying data:

```elixir
# Gremlin Syntax!
MyApp.MyGraph.query("graph.Vertex('graph').Out('connection').All()")
```

Deleting Data:

```elixir
# single quad
MyApp.MyGraph.delete(%{
  subject:   "graph",
  predicate: "connection",
  object:    "target"
})

# multiple quads (bulk delete)
MyApp.MyGraph.delete([ quad_1, quad_2 ])
```


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
