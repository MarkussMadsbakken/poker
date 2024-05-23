defmodule Poker.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :gameid, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:gameid])
    |> validate_required([:gameid])
  end
end
