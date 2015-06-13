defmodule Caylir.Graph do
  @moduledoc """
  Base module to define graph connections.

  All graph connections will be made using a user-defined
  extension of this module.

  ## Example Module

      defmodule MyGraph do
        use Caylir.Graph, otp_app: :my_application
      end

  ## Example Configuration

      config :my_application, MyGraph,
        host: "localhost",
        port: 64210
  """

  use Behaviour

  defmacro __using__(otp_app: otp_app) do
    quote do
      alias Caylir.Graph.Connection

      @behaviour unquote(__MODULE__)
      @otp_app   unquote(otp_app)

      def child_spec, do: Connection.child_spec(__MODULE__)
      def config,     do: Connection.Config.config(@otp_app, __MODULE__)

      def delete(quad), do: Connection.delete(__MODULE__, quad)
      def query(query), do: Connection.query(__MODULE__, query)
      def shape(query), do: Connection.shape(__MODULE__, query)
      def write(quad),  do: Connection.write(__MODULE__, quad)
    end
  end

  @type t_delete :: :ok | { :error, String.t }
  @type t_query :: any | { :error, String.t }
  @type t_write :: :ok | { :error, String.t }

  @doc """
  Returns the child specification to start and supervise the graph connection.
  """
  defcallback child_spec :: Supervisor.Spec.spec

  @doc """
  Should return the configuration options used to communicate with the graph.

  Needed parameters:

  - host
  - port
  """
  defcallback config :: Keyword.t

  @doc """
  Deletes a quad from the graph.
  """
  defcallback delete(Keyword.t) :: t_delete

  @doc """
  Queries the graph.
  """
  defcallback query(String.t) :: t_query

  @doc """
  Gets the shape of a query.
  """
  defcallback shape(String.t) :: t_query

  @doc """
  Writes a quad to the graph.
  """
  defcallback write(Keyword.t) :: t_write
end
