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
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # TODO improve this 
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> notify_subs([:message, :inserted])
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

  defp parse_message(message) do
    content = Map.get(message, "content")
    cond do
      Regex.match?(~r{^/r (\d+)d(\d+)}, content) ->
        [_ , number, faces] = Regex.run(~r{^/r (\d+)d(\d+)}, content)
        { :rolled, message, %{number: number, faces: faces} }
      true ->
        { :ok, message}
    end
  end

  def process_message(message) do
    input = parse_message(message)
    case input do
      { :rolled, message, data } ->
        username = Map.get(message, "username")
        room = Map.get(message, "room")
        roll = roller(data)
        content = "#{username} rolled #{data.number}d#{data.faces}:  #{roll}"
        create_message( %{room: room, username: username, content: content} )
      { :ok, message } ->
        create_message(message)
    end
  end

  defp roller(data) do
    { number, _ } = Integer.parse(data.number)
    { faces, _ } = Integer.parse(data.faces)
    cond do 
      faces > 1000 ->
        "Error, the dice has too many faces. Try less than 1000"
      number > 50 ->
        "Error, too many dices. Try less than 50"
      true ->
        Enum.map(1..number, fn _ -> :rand.uniform(faces) end)
        |> Enum.join(" + ")
    end
  end
end
