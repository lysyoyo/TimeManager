defmodule Batman.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BatmanWeb.Telemetry,
      Batman.Repo,
      {DNSCluster, query: Application.get_env(:batman, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Batman.PubSub},
      {Finch, name: Batman.Finch},
      BatmanWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Batman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BatmanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
