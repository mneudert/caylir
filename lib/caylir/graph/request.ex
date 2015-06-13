defmodule Caylir.Graph.Request do
  @moduledoc """
  Sends requests to the server.
  """

  @doc """
  Send a request to the server.
  """
  @spec send({ atom, String.t, String.t }) :: any
  def send({ method, url, payload }) do
    body    = payload |> :binary.bin_to_list()
    headers = [{ 'Content-Type',  'application/x-www-form-urlencoded' },
               { 'Content-Length', length(body) }]

    { :ok, status, _, client } = :hackney.request(method, url, headers, body)
    { :ok, response }          = :hackney.body(client)

    parse_response(status, response)
  end


  defp parse_response(status, ''),  do: { :ok, status }
  defp parse_response(status, body) do
    { :ok, status, Poison.decode!(body, keys: :atoms) }
  end
end
