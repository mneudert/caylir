alias Caylir.TestHelpers.Graphs
alias Caylir.TestHelpers.VersionDetector

# start fake server
root = Kernel.to_charlist(__DIR__)

httpd_config = [
  document_root: root,
  modules: [:caylir_testhelpers_inets_proxy],
  port: 0,
  server_name: 'caylir_testhelpers_inets_proxy',
  server_root: root
]

{:ok, httpd_pid} = :inets.start(:httpd, httpd_config)

inets_env =
  :caylir
  |> Application.get_env(Graphs.InetsGraph)
  |> Keyword.put(:port, :httpd.info(httpd_pid)[:port])

Application.put_env(:caylir, Graphs.InetsGraph, inets_env)

# start graphs
Supervisor.start_link(
  [
    Graphs.DefaultGraph,
    Graphs.EnvGraph,
    Graphs.InetsGraph,
    Graphs.LimitGraph
  ],
  strategy: :one_for_one
)

# configure Cayley test exclusion
config = ExUnit.configuration()
version = VersionDetector.detect(Graphs.DefaultGraph)

config =
  case Version.parse(version) do
    :error ->
      config

    {:ok, version} ->
      versions = ["0.6.1", "0.7.0"]
      config = Keyword.put(config, :exclude, config[:exclude] || [])

      Enum.reduce(versions, config, fn ver, acc ->
        case Version.match?(version, "== #{ver}") do
          true -> acc
          false -> Keyword.put(acc, :exclude, [{:cayley_version, ver} | acc[:exclude]])
        end
      end)
  end

IO.puts("Running tests for Cayley version: #{version}")

# configure graph query language (if necessary)
if Version.match?(version, "== 0.6.1") do
  Enum.each([Graphs.DefaultGraph, Graphs.EnvGraph, Graphs.InetsGraph], fn graph ->
    Application.put_env(
      :caylir,
      graph,
      Keyword.put(Application.get_env(:caylir, graph, []), :language, :gremlin)
    )
  end)
end

# start ExUnit
ExUnit.start(config)
