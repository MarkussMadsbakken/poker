defmodule Poker.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :gameid, :string
      add :content, :string
      add :username, :string

      timestamps(type: :utc_datetime)
    end
  end
end
