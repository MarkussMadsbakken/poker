defmodule Poker.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Poker.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        gameid: "some gameid"
      })
      |> Poker.Games.create_game()

    game
  end
end
