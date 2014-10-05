defmodule Caylir.Graph do
  @moduledoc """
  Base module to define graph connections.

  ## Example

      defmodule SomeGraph do
        use Caylir.Graph

        def conf() do
          [ host: "localhost", port: 64210 ]
        end
      end
  """

  use Behaviour

  defmacro __using__(_opts) do
    quote do
      alias Caylir.Graph.Connection

      @behaviour unquote(__MODULE__)

      def child_spec() do
        Connection.child_spec(__MODULE__)
      end
    end
  end

  @doc """
  Should return the configuration options used to communicate with the graph.

  Needed parameters:

  - host
  - port
  """
  defcallback conf() :: Keyword.t

  @doc """
  Returns the child specification to start and supervise the graph connection.
  """
  defcallback child_spec() :: Supervisor.Spec.spec
end
