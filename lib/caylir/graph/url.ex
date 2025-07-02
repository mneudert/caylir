defmodule Caylir.Graph.URL do
  @moduledoc false

  @doc """
  Returns the URL for deleting quads.

  ## Example

      iex> delete([])
      "http://localhost:64210/api/v1/delete"

      iex> delete(scheme: "https")
      "https://localhost:64210/api/v1/delete"

      iex> delete(host: "cayley.host", port: 42160)
      "http://cayley.host:42160/api/v1/delete"
  """
  @spec delete(Keyword.t()) :: String.t()
  def delete(config) do
    "delete"
    |> url(config)
    |> URI.to_string()
  end

  @doc """
  Returns the URL to query the graph.

  ## Example

      iex> query([])
      "http://localhost:64210/api/v1/query/gizmo"

      iex> query(scheme: "https")
      "https://localhost:64210/api/v1/query/gizmo"

      iex> query(host: "cayley.host", port: 42160)
      "http://cayley.host:42160/api/v1/query/gizmo"

      iex> query(host: "cayley.host", port: 42160, language: :gizmo)
      "http://cayley.host:42160/api/v1/query/gizmo"

      iex> query(host: "cayley.host", port: 42160, language: :gizmo, limit: 3)
      "http://cayley.host:42160/api/v1/query/gizmo?limit=3"

      iex> query(host: "cayley.host", port: 42160, language: :graphql, limit: 3)
      "http://cayley.host:42160/api/v1/query/graphql?limit=3"
  """
  @spec query(Keyword.t()) :: String.t()
  def query(config) do
    "query"
    |> url_with_language(config)
    |> query_limit(config[:limit])
    |> URI.to_string()
  end

  @doc """
  Returns the URL to get the shape of a query.

  ## Example

      iex> shape([])
      "http://localhost:64210/api/v1/shape/gizmo"

      iex> shape(scheme: "https")
      "https://localhost:64210/api/v1/shape/gizmo"

      iex> shape(host: "cayley.host", port: 42160)
      "http://cayley.host:42160/api/v1/shape/gizmo"

      iex> shape(host: "cayley.host", port: 42160, language: :gizmo)
      "http://cayley.host:42160/api/v1/shape/gizmo"

      iex> shape(host: "cayley.host", port: 42160, language: :mql)
      "http://cayley.host:42160/api/v1/shape/mql"
  """
  @spec shape(Keyword.t()) :: String.t()
  def shape(config) do
    "shape"
    |> url_with_language(config)
    |> URI.to_string()
  end

  @doc """
  Returns the URL for writing quads.

  ## Example

      iex> write([])
      "http://localhost:64210/api/v1/write"

      iex> write(scheme: "https")
      "https://localhost:64210/api/v1/write"

      iex> write(host: "cayley.host", port: 42160)
      "http://cayley.host:42160/api/v1/write"
  """
  @spec write(Keyword.t()) :: String.t()
  def write(config) do
    "write"
    |> url(config)
    |> URI.to_string()
  end

  defp url(action, config) do
    %URI{
      scheme: Keyword.get(config, :scheme, "http"),
      host: Keyword.get(config, :host, "localhost"),
      port: Keyword.get(config, :port, 64_210),
      path: "/api/v1/" <> URI.encode(action)
    }
  end

  defp url_with_language(action, config) do
    url = url(action, config)
    language = config[:language] |> query_language() |> URI.encode()

    %{url | path: url.path <> "/" <> language}
  end

  defp query_language(nil), do: "gizmo"
  defp query_language(language), do: Kernel.to_string(language)

  defp query_limit(url, limit) when is_integer(limit) do
    %{url | query: "limit=#{limit}"}
  end

  defp query_limit(url, _), do: url
end
