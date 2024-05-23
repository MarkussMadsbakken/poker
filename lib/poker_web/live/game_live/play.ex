defmodule PokerWeb.GameLive.Play do
  use PokerWeb, :live_view

  alias Poker.Games

  @impl true
  def mount(params, _session, socket) do
    PokerWeb.Endpoint.subscribe("clicks#{params["id"]}")

    {:ok, assign(socket, :clicks, 0)}
  end

  # handle params is called when the LiveView is mounted
  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, Games.get_game!(id))}
  end

  # handle_event is called when the LiveView receives an event
  @impl true
  def handle_event("btn-click", _, socket) do
    new_clicks = socket.assigns.clicks + 1

    PokerWeb.Endpoint.broadcast("clicks#{socket.assigns.game.id}", "new-click", new_clicks)

    {:noreply, assign(socket, :clicks, new_clicks)}
  end

  # handle_info is called when the LiveView receives a broadcast
  @impl true
  def handle_info(
        %{event: "new-click", payload: new_clicks},
        socket
      ) do
    {:noreply, assign(socket, :clicks, new_clicks)}
  end

  defp page_title(:play), do: "Playing Game"
end
