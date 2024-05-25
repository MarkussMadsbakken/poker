defmodule Poker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, redact: true
    field :joined, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :userId, :password, :joined])
    |> validate_required([:username, :userId, :password, :joined])
    |> unique_constraint([:username])
    |> unique_constraint([:userId])
  end
end
