defmodule Poker.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :gameid, :string

    has_many :users, Poker.Users.User
    has_many :messages, Poker.Chat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:gameid])
    |> validate_required([:gameid])
    |> unique_constraint([:gameid])
  end
end
