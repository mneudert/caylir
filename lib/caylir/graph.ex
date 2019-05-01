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
        pool: [max_overflow: 10, size: 5],
        port: 64210,
        language: :gizmo
  """

  defmacro __using__(opts) do
    unless Keyword.has_key?(opts, :otp_app) do
      raise ArgumentError, "missing :otp_app value for graph #{__CALLER__.module}"
    end

    quote do
      alias Caylir.Graph.Config
      alias Caylir.Graph.Request

      @behaviour unquote(__MODULE__)

      @otp_app unquote(opts[:otp_app])
      @config unquote(opts[:config] || [])

      def child_spec(_ \\ []) do
        Supervisor.Spec.supervisor(
          Caylir.Graph.Supervisor,
          [__MODULE__],
          id: __MODULE__.Supervisor
        )
      end

      def config, do: Config.config(@otp_app, __MODULE__, @config)

      def delete(quad, opts \\ []), do: Request.delete(quad, __MODULE__, opts)
      def query(query, opts \\ []), do: Request.query(query, __MODULE__, opts)
      def shape(query, opts \\ []), do: Request.shape(query, __MODULE__, opts)
      def write(quad, opts \\ []), do: Request.write(quad, __MODULE__, opts)
    end
  end

  @type t_delete :: :ok | {:error, String.t()}
  @type t_query :: any | {:error, String.t()}
  @type t_write :: :ok | {:error, String.t()}

  @doc """
  Returns a supervisable graph child_spec.
  """
  @callback child_spec(_ignored :: term) :: Supervisor.Spec.spec()

  @doc """
  Returns the graph configuration.
  """
  @callback config :: Keyword.t()

  @doc """
  Deletes a quad from the graph.
  """
  @callback delete(quad :: map | [map], opts :: Keyword.t()) :: t_delete

  @doc """
  Queries the graph.
  """
  @callback query(query :: String.t(), opts :: Keyword.t()) :: t_query

  @doc """
  Gets the shape of a query.
  """
  @callback shape(query :: String.t(), opts :: Keyword.t()) :: t_query

  @doc """
  Writes a quad to the graph.
  """
  @callback write(quad :: map | [map], opts :: Keyword.t()) :: t_write
end
