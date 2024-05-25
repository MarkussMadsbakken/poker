defmodule PokerWeb.GameLive.Play do
  use PokerWeb, :live_view

  alias Poker.Games

  alias Poker.Chat

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:chat_text, nil)
     |> assign(:chats_loaded, 0)
     |> assign(:scrolled_to_top, "false")}
  end

  # handle params is called when the LiveView is mounted
  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    game = Games.get_game!(id)

    if connected?(socket), do: Poker.Chat.subscribe(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, game)
     |> stream(:messages, Chat.get_messages(id, 0), at: 0)
     |> assign(:chats_loaded, 1)}
  end

  defp page_title(:play), do: "Poker: Playing Game"

  @impl true
  def handle_info({:new_chat_message, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message, at: -1)}
  end

  @impl true
  def handle_event("change", %{"text" => text}, socket) do
    {:noreply, assign(socket, :chat_text, text)}
  end

  @impl true
  def handle_event("send_message", %{"text" => message}, socket) do
    Poker.Chat.send_message(socket.assigns.game.gameid, message)
    {:noreply, assign(socket, :chat_text, nil)}
  end

  def handle_event("unpin_scrollbar_from_top", _data, socket) do
    IO.inspect("unpinning")
    {:noreply, assign(socket, :scrolled_to_top, "false")}
  end

  @impl true
  def handle_event("load_more", _data, socket) do
    socket = assign(socket, :scrolled_to_top, "false")

    socket =
      stream(
        socket,
        :messages,
        Enum.reverse(Chat.get_messages(socket.assigns.game.gameid, socket.assigns.chats_loaded)),
        at: 0
      )

    {:noreply, assign(socket, :chats_loaded, socket.assigns.chats_loaded + 1)}
  end
end
