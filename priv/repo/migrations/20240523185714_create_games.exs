defmodule Poker.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :gameid, :string

      timestamps(type: :utc_datetime)
    end
  end
end
