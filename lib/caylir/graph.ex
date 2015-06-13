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
        pool: [ max_overflow: 10, size: 5 ],
        port: 64210
  """

  use Behaviour

  defmacro __using__(otp_app: otp_app) do
    quote do
      alias Caylir.Graph.Config
      alias Caylir.Graph.Pool

      @behaviour unquote(__MODULE__)
      @otp_app   unquote(otp_app)

      def __pool__, do: __MODULE__.Pool

      def child_spec, do: Pool.Spec.spec(__MODULE__)
      def config,     do: Config.config(@otp_app, __MODULE__)

      def delete(quad), do: send { :delete, quad }
      def query(query), do: send { :query, query }
      def shape(query), do: send { :shape, query }
      def write(quad),  do: send { :write, quad }

      defp send(request) do
        :poolboy.transaction(__pool__, &GenServer.call(&1, request))
      end
    end
  end

  @type t_delete :: :ok | { :error, String.t }
  @type t_query :: any | { :error, String.t }
  @type t_write :: :ok | { :error, String.t }

  @doc """
  Returns the (internal) pool module.
  """
  defcallback __pool__ :: module

  @doc """
  Returns a supervisable pool child_spec.
  """
  defcallback child_spec :: Supervisor.Spec.spec

  @doc """
  Returns the connection configuration.
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
