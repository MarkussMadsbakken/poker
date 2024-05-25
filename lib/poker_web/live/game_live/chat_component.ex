defmodule PokerWeb.GameLive.ChatComponent do
  use Phoenix.LiveComponent

  import PokerWeb.CoreComponents

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :text, nil)}
  end

  attr :messages, :list, default: []
  attr :text, :string
  attr :scrolled_to_top, :string, default: "false"
  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex max-h-full h-full">
      <div class="flex border border-neutral-500 rounded-xl max-h-full mr-4 ml-4 mb-6 mt-4 p-2 flex flex-col-reverse ">
        <!-- Submission form -->
        <form class="flex flex-row h-14 w-full" phx-submit="send_message" phx-change="change">
          <.input
            class="w-full h-full"
            type="text"
            name="text"
            value={@text}
            placeholder="Type a message..."
          />
          <.button class="w-1/3 h-full ml-2 lg:block hidden min-w-fit">
            Send
          </.button>
        </form>
        <!-- Chat messages -->
        <div
          class="h-full flex flex-col overflow-y-scroll overflow-x-hidden p-2 scrollbar-hide"
          phx-hook="ScrollDown"
          data-scrolled-to-top={@scrolled_to_top}
          id="chat_messages_container"
        >
          <div class="font-semibold text-sm flex items-center justify-center">
            This is the beginning of the chat
          </div>
          
          <div id="infnite_scroll_marker" phx-hook="InfiniteScroll"></div>
          
          <div phx-update="stream" id="chat_messages" data-scrolled-to-top={@scrolled_to_top}>
            <div :for={{id, message} <- @messages} id={id} class="flex flex-row items-center">
              <div class=" text-neutral-300 font-semibold">
                <%= message.username %>
              </div>
              
              <div class="text-white p-2 overflow-auto break-words">
                <%= message.content %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
