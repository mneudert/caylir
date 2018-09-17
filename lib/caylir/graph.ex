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
        host:     "localhost",
        pool:     [ max_overflow: 10, size: 5 ],
        port:     64210,
        language: :gizmo
  """

  defmacro __using__(opts) do
    unless Keyword.has_key?(opts, :otp_app) do
      raise ArgumentError, "missing :otp_app value for graph #{__CALLER__.module}"
    end

    quote do
      alias Caylir.Graph.Config
      alias Caylir.Graph.Pool

      @behaviour unquote(__MODULE__)

      @otp_app unquote(opts[:otp_app])
      @config unquote(opts[:config] || [])

      def __pool__, do: __MODULE__.Pool

      def child_spec(_ \\ []) do
        Supervisor.Spec.supervisor(
          Caylir.Graph.Supervisor,
          [__MODULE__],
          id: __MODULE__.Supervisor
        )
      end

      def pool_spec, do: Pool.Spec.spec(__MODULE__)

      def config, do: Config.config(@otp_app, __MODULE__, @config)

      def delete(quad), do: send({:delete, quad})
      def query(query, opts \\ []), do: send({:query, query, opts})
      def shape(query), do: send({:shape, query})
      def write(quad), do: send({:write, quad})

      defp send(request) do
        :poolboy.transaction(__pool__(), &GenServer.call(&1, request))
      end
    end
  end

  @type t_delete :: :ok | {:error, String.t()}
  @type t_query :: any | {:error, String.t()}
  @type t_write :: :ok | {:error, String.t()}

  @doc """
  Returns the (internal) pool module.
  """
  @callback __pool__ :: module

  @doc """
  Returns a supervisable graph child_spec.
  """
  @callback child_spec(_ignored :: term) :: Supervisor.Spec.spec()

  @doc """
  Returns the connection configuration.
  """
  @callback config :: Keyword.t()

  @doc """
  Deletes a quad from the graph.
  """
  @callback delete(map | [map]) :: t_delete

  @doc """
  Returns a supervisable pool child_spec.
  """
  @callback pool_spec :: Supervisor.Spec.spec()

  @doc """
  Queries the graph.
  """
  @callback query(String.t()) :: t_query

  @doc """
  Queries the graph with specific query options.
  """
  @callback query(String.t(), list()) :: t_query

  @doc """
  Gets the shape of a query.
  """
  @callback shape(String.t()) :: t_query

  @doc """
  Writes a quad to the graph.
  """
  @callback write(map | [map]) :: t_write
end
