defmodule Caylir.Graph.Response do
  @moduledoc """
  Helper module to decode graph responses.
  """

  @type response :: { :ok, term } | { :error, term }
  @type result :: { :ok, integer } |
                  { :ok, integer, Poison.Parser.t } |
                  { :ok, integer, term } |
                  { :error, term }

  @doc """
  Parses a response.

  If the response contains a body it is automatically JSON decoded.
  """
  @spec parse(response) :: result

  def parse({ :ok, {{ _, status, _ }, _, [] }}), do: { :ok, status }

  def parse({ :ok, {{ _, status, _ }, _, body }}) do
    { :ok, status, Poison.decode!(body, keys: :atoms) }
  end

  def parse({ :error, reason }), do: { :error, reason }
end
