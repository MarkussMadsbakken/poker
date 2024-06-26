defmodule Poker.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Poker.Repo

  alias Poker.Games.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(gameid) do
    query =
      from(g in Game,
        where: g.gameid == ^gameid,
        select: g
      )

    Repo.one(query)
  end

  @spec create_game() :: {:err, any()} | {:ok, any()}
  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game() do
    %Game{}
    |> Game.changeset(%{gameid: generate_gameid()})
    |> Repo.insert()
    |> broadcast(:new_game)
  end

  def create_gameid() do
    generate_gameid()
  end

  @spec generate_gameid() :: binary()
  def generate_gameid() do
    length = 4
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    chars_list = for <<ch::utf8 <- chars>>, do: <<ch::utf8>>

    Enum.take_random(chars_list, length) |> Enum.join()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update_game)
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
    |> broadcast(:delete_game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """

  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Subscribes to the games channel
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Poker.PubSub, "games")
  end

  defp broadcast({:err, _reason} = error, _event), do: error

  defp broadcast({:ok, game}, event) do
    Phoenix.PubSub.broadcast(Poker.PubSub, "games", {event, game})
    {:ok, game}
  end
end
