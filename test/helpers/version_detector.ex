defmodule Caylir.TestHelpers.VersionDetector do
  @moduledoc """
  Tries to detect the currently running cayley version.
  """

  @doc """
  Performs version detection.
  """
  @spec detect(module) :: String.t()
  def detect(graph) do
    gremlin_url = Caylir.Graph.URL.query(graph.config())

    {:ok, 200, _, client} = :hackney.post(gremlin_url)
    {:ok, response} = :hackney.body(client)

    case %{"error" => "Unknown query language."} == Poison.decode!(response) do
      false -> "0.6.1"
      true -> "0.7.0"
    end
  end
end
