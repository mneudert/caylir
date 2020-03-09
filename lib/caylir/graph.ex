defmodule Caylir.Graph do
  @moduledoc """
  Defines a connection to a Cayley instance.

  ## Graph definition

      defmodule MyGraph do
        use Caylir.Graph, otp_app: :my_application
      end

  This connection will fetch it's configuration from the application environment
  as defined by `:otp_app`. As an alternative you can define the configuration
  in the module definition itself:

      defmodule MyGraph do
        use Caylir.Graph,
          config: [
            host: "cayley.example.com"
          ]

  Both inline and `:otp_app` configuration can be mixed. In this case the
  application configuration will overwrite any inline values.

  For more information on how to configure your connection please refer to
  the documentation of `Caylir.Graph.Config`.
  """

  defmacro __using__(opts) do
    quote do
      alias Caylir.Graph.Config
      alias Caylir.Graph.Initializer
      alias Caylir.Graph.Request

      @behaviour unquote(__MODULE__)

      @otp_app unquote(opts[:otp_app])
      @config unquote(opts[:config] || [])

      def child_spec(_) do
        initializer = Module.concat(__MODULE__, Initializer)
        spec = %{graph: __MODULE__, initializer: initializer}

        %{
          id: initializer,
          start: {Initializer, :start_link, [spec]}
        }
      end

      def config, do: Config.config(@otp_app, __MODULE__, @config)

      def delete(quad, opts \\ []), do: Request.delete(quad, __MODULE__, opts)
      def query(query, opts \\ []), do: Request.query(query, __MODULE__, opts)
      def shape(query, opts \\ []), do: Request.shape(query, __MODULE__, opts)
      def write(quad, opts \\ []), do: Request.write(quad, __MODULE__, opts)
    end
  end

  @type t_quad :: %{
          :subject => binary,
          :predicate => binary,
          :object => binary,
          optional(:label) => binary
        }

  @type t_delete :: :ok | {:error, String.t()}
  @type t_query :: any | {:error, String.t()}
  @type t_write :: :ok | {:error, String.t()}

  @doc """
  Returns a supervisable graph child_spec.
  """
  @callback child_spec(_ignored :: term) :: Supervisor.child_spec()

  @doc """
  Returns the graph configuration.
  """
  @callback config :: Keyword.t()

  @doc """
  Deletes a quad from the graph.
  """
  @callback delete(quad :: t_quad | [t_quad], opts :: Keyword.t()) :: t_delete

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
  @callback write(quad :: t_quad | [t_quad], opts :: Keyword.t()) :: t_write
end
