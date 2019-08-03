defmodule LiveViewDemo.Room do
  @moduledoc """
  The Room context.
  """

  import Ecto.Query, warn: false
  alias LiveViewDemo.Repo

  alias LiveViewDemo.Message

  @doc """
  Returns the list of messages that belongs to the specified room.

  ## Examples

      iex> messages(room)
      [%Message{}, ...]

  """
  def messages(room) do
    query = from(m in Message, where: m.room == ^room)
    Repo.all(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
  
  def subscribe(room \\ "room:general") do
    Phoenix.PubSub.subscribe(LiveViewDemo.PubSub, room)
  end

  defp notify_subs({:ok, result}, event) do
    Phoenix.PubSub.broadcast(LiveViewDemo.PubSub, result.room, {result.room, event, result})
    {:ok, result}
  end

  defp notify_subs({:error, reason}, _event) do
    {:error, reason}
  end
end
