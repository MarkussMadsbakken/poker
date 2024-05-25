defmodule PokerWeb.GameLive.GamecardComponent do
  use Phoenix.LiveComponent

  import PokerWeb.CoreComponents

  @impl true
  attr :gameid, :string, required: true
  attr :users, :list, default: []

  def render(assigns) do
    ~H"""
    <div class="w-96 h-32 border border-white flex flex-col justify-center items-center space-y-2">
      <div class="text-center">
        Game ID: <%= @gameid %>
      </div>
      
      <.button phx-click="join_game" phx-target={@myself} class="w-1/2">Join Game</.button>
      
      <div>Users: <%= Enum.join(@users, ", ") %></div>
    </div>
    """
  end

  @impl true
  def handle_event("join_game", _params, socket) do
    IO.inspect(socket.assigns)
    {:noreply, push_navigate(socket, to: "/games/#{socket.assigns.gameid}")}
  end
end
