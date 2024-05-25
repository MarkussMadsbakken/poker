defmodule PokerWeb.GameLive.Index do
  use PokerWeb, :live_view

  alias Poker.Games
  alias Poker.Games.Game

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Poker.Games.subscribe()

    {:ok, stream(socket, :games, Games.list_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :play, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Games.get_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, %Game{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Games")
    |> assign(:game, nil)
  end

  @impl true
  def handle_info({PokerWeb.GameLive.FormComponent, {:saved, game}}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_info({:new_game, game}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_info({:update_game, game}, socket) do
    {:noreply, update(socket, :games, game)}
  end

  @impl true
  def handle_info({:delete_game, game}, socket) do
    {:noreply, stream_delete(socket, :games, game)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Games.get_game!(id)
    {:ok, _} = Games.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end

  @impl true
  def handle_event("create_new_game", _, socket) do
    case Games.create_game() do
      {:ok, game} ->
        {:noreply, stream_insert(socket, :games, game)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :game, changeset)}
    end
  end
end
