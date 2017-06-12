-module(caylir_testhelpers_inets_proxy).

-export([do/1]).

do(ModData) ->
    'Elixir.Caylir.TestHelpers.Inets.Handler':serve(ModData).
