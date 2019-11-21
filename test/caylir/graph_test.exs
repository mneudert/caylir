defmodule Caylir.GraphTest do
  use ExUnit.Case, async: true

  defmodule DefaultGraph do
    # credo:disable-for-lines:6 Credo.Check.Readability.LargeNumbers
    use Caylir.Graph, otp_app: :caylir
  end

  defmodule DefaultGraphJSONStringKeys do
    # credo:disable-for-lines:6 Credo.Check.Readability.LargeNumbers
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        json_decoder: {Jason, :decode!, [[keys: :strings]]}
      ]
  end

  defmodule LimitGraph do
    # credo:disable-for-lines:7 Credo.Check.Readability.LargeNumbers
    use Caylir.Graph,
      otp_app: :caylir,
      config: [
        limit: 1
      ]
  end

  test "missing :otp_app raises when compiling" do
    assert_raise ArgumentError, ~r/missing :otp_app.+MissingOTPAppGraph/, fn ->
      defmodule MissingOTPAppGraph do
        use Caylir.Graph
      end
    end
  end

  test "invalid quads fail deleting" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:ok, _} = start_supervised(DefaultGraphJSONStringKeys)
    {:error, reason} = DefaultGraph.delete(%{invalid: "quad"})

    assert {:error, ^reason} = DefaultGraphJSONStringKeys.delete(%{invalid: "quad"})
    assert String.contains?(reason, "invalid quad")
  end

  test "invalid quads fail writing" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:ok, _} = start_supervised(DefaultGraphJSONStringKeys)
    {:error, reason} = DefaultGraph.write(%{invalid: "quad"})

    assert {:error, ^reason} = DefaultGraphJSONStringKeys.write(%{invalid: "quad"})
    assert String.contains?(reason, "invalid quad")
  end

  test "invalid query string" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:ok, _} = start_supervised(DefaultGraphJSONStringKeys)
    {:error, reason} = DefaultGraph.query("meh!")

    assert {:error, ^reason} = DefaultGraphJSONStringKeys.query("meh!")
    assert String.contains?(reason, "Unexpected token")
  end

  test "invalid shape query string" do
    {:ok, _} = start_supervised(DefaultGraph)
    {:ok, _} = start_supervised(DefaultGraphJSONStringKeys)
    {:error, reason} = DefaultGraph.shape("meh!")

    assert {:error, ^reason} = DefaultGraphJSONStringKeys.shape("meh!")
    assert String.contains?(reason, "Unexpected token")
  end

  test "quad lifecycle", context do
    {:ok, _} = start_supervised(DefaultGraph)
    {:ok, _} = start_supervised(DefaultGraphJSONStringKeys)

    quad = %{subject: "lifecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('lifecycle').Out('for').All()"
    result_atoms = [%{id: to_string(context.test)}]
    result_strings = [%{"id" => to_string(context.test)}]

    assert :ok == DefaultGraph.write(quad)

    assert result_atoms == DefaultGraph.query(query)
    assert result_strings == DefaultGraphJSONStringKeys.query(query)

    assert :ok == DefaultGraph.delete(quad)

    assert nil == DefaultGraph.query(query)
    assert nil == DefaultGraphJSONStringKeys.query(query)
  end

  test "query shape", context do
    {:ok, _} = start_supervised(DefaultGraph)
    {:ok, _} = start_supervised(DefaultGraphJSONStringKeys)

    quad = %{subject: "shapecycle", predicate: "for", object: to_string(context.test)}
    query = "graph.Vertex('shapecycle').Out('for').All()"

    :ok = DefaultGraph.write(quad)

    shape_atoms = DefaultGraph.shape(query)
    shape_strings = DefaultGraphJSONStringKeys.shape(query)

    assert Map.has_key?(shape_atoms, :links)
    assert Map.has_key?(shape_atoms, :nodes)

    assert Map.has_key?(shape_strings, "links")
    assert Map.has_key?(shape_strings, "nodes")
  end

  test "query result limiting", context do
    {:ok, _} = start_supervised(LimitGraph)

    quads = [
      %{subject: "query_limiting", predicate: "for", object: "#{context.test} #1"},
      %{subject: "query_limiting", predicate: "for", object: "#{context.test} #2"}
    ]

    # `All()` only respects limit in Cayley 0.7.4+
    # graph.Vertex('query_limiting').Out('for').All()"
    query = "graph.Vertex('query_limiting').Out('for').ForEach( function(d) { g.Emit(d) })"

    assert :ok == LimitGraph.write(quads)

    assert 1 == length(LimitGraph.query(query))
    assert 2 == length(LimitGraph.query(query, limit: -1))
    assert 1 == length(LimitGraph.query(query, limit: 1))

    assert :ok == LimitGraph.delete(quads)
  end
end
