defmodule Poker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PokerWeb.Telemetry,
      Poker.Repo,
      {DNSCluster, query: Application.get_env(:poker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Poker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Poker.Finch},
      # Start a worker by calling: Poker.Worker.start_link(arg)
      # {Poker.Worker, arg},
      # Start to serve requests, typically the last entry
      PokerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Poker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PokerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
