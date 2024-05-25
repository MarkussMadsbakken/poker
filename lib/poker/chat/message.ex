defmodule Poker.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :gameid, :string
    field :content, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :username, :gameid])
    |> validate_required([:content, :username, :gameid])
  end
end
