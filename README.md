# Caylir

Cayley driver for Elixir


## Warning

__This module is highly experimental at the moment and may behave or change unexpectedly.__


## Setup

Add Caylir as a dependency to your `mix.exs` file:

```elixir
defp deps do
  [ { :caylir, github: "mneudert/caylir" } ]
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
  use Caylir.Graph

  def conf(), do: [ host: "localhost", port: 64210 ]
end
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
MyApp.MyGraph.write(%{
  subject:   "graph",
  predicate: "connection",
  object:    "target"
})
```

Querying data:

```elixir
# Gremlin Syntax!
MyApp.MyGraph.query("graph.Vertex('graph').Out('connection').All()")
```

Deleting Data:

```elixir
MyApp.MyGraph.delete(%{
  subject:   "graph",
  predicate: "connection",
  object:    "target"
})
```


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
