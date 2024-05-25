defmodule PokerWeb.LoadingComponents do
  use Phoenix.Component

  def spinner(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-full">
      <div class="animate-spin rounded-full h-32 w-32 border-b-2 border-gray-900"></div>
    </div>
    """
  end
end
