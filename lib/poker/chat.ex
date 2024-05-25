defmodule Poker.Chat do
  import Ecto.Query, warn: false
  alias Poker.Repo

  alias Poker.Chat.Message

  @doc """
  Sends a chat message to a game given a gameid.
  """
  def send_message(gameid, message) do
    %Message{}
    |> Message.changeset(%{gameid: gameid, content: message, username: "test"})
    |> Repo.insert()
    |> broadcast(:new_chat_message)
  end

  @doc """
  Lists all messages for a game given a gameid.
  """
  def list_messages(gameid) do
    query =
      from(m in Message,
        where: m.gameid == ^gameid,
        order_by: [asc: m.inserted_at],
        select: m
      )

    Repo.all(query)
  end

  def delete_messages(gameid) do
    query =
      from(m in Message,
        where: m.gameid == ^gameid
      )

    Repo.delete_all(query)
  end

  @doc """
  Returns 15 messages for a game given a gameid and an offset.
  """
  def get_messages(gameid, offset) do
    get_messages(gameid, 15, offset * 15)
  end

  defp get_messages(gameid, limit, offset) do
    query =
      from(m in Message,
        where: m.gameid == ^gameid,
        order_by: [desc: m.inserted_at],
        limit: ^limit,
        offset: ^offset,
        select: m
      )

    Enum.reverse(Repo.all(query))
  end

  @doc """
  Subscribes to a chat channel.
  """
  def subscribe(gameid) do
    IO.inspect("subscribing to chat#{gameid}")
    Phoenix.PubSub.subscribe(Poker.PubSub, "chat#{gameid}")
  end

  defp broadcast({:err, _reason} = error, _event), do: error

  defp broadcast({:ok, message}, event) do
    IO.inspect("sending message to chat#{message.gameid}")
    Phoenix.PubSub.broadcast(Poker.PubSub, "chat#{message.gameid}", {event, message})
    {:ok, message}
  end
end
