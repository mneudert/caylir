defmodule Caylir.Graph.Request do
  @moduledoc """
  Sends requests to the server.
  """

  @doc """
  Send a request to the server.
  """
  @spec send({ atom, binary, list, binary }) :: term
  def send({ method, url, headers, body }) do
    { :ok, status, _, client } = :hackney.request(method, url, headers, body)
    { :ok, response }          = :hackney.body(client)

    parse_response(status, response)
  end


  defp parse_response(status, ''),  do: { :ok, status }
  defp parse_response(status, body) do
    { :ok, status, Poison.decode!(body, keys: :atoms) }
  end
end
