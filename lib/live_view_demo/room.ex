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

  def last_video(room) do
    query = from(m in Message, where: m.room == ^room, order_by: [desc: m.id], limit: 1)
    message = Repo.one(query)
    message.video
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
    content = message["content"]
    cond do
      Regex.match?(~r{^/r (\d+)d(\d+)}, content) ->
        [_ , number, faces] = Regex.run(~r{^/r (\d+)d(\d+)}, content)
        { :rolled, message, %{number: number, faces: faces} }
      true ->
        { :ok, message}
    end
  end

  # TODO DO PATTERN MATCHING
  def process_message(message) do
    video = message["video"] || Room.last_video(message.room)
    username = message["username"]
    room = message["room"]
    content = message["content"]
    if (video != "") do
      create_message( %{room: room, username: username, content: "Changed video", video: parse_video(video)} )
    else
      input = parse_message(message)
      case input do
        { :rolled, message, data } ->
          room = room
          roll = roller(data)
          content = "Rolled: #{data.number}d#{data.faces}:  #{roll}"
          create_message( %{room: room, username: username, content: content, video: video} )
        { :ok, message } ->
          create_message(%{room: room, username: username, content: content, video: video})
      end
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
  
  defp parse_video(video) do
    query = URI.parse(video).query
    parsed_params = URI.query_decoder(query) |> Enum.into(%{}) 
    video_index = parsed_params["index"] || "0"
    video_time = parsed_params["start"] || "0"
    parsed_video = "https://www.youtube.com/embed/"
    
    parsed_video =
      cond do
        parsed_params["list"] ->
          "#{parsed_video}videoseries?list=#{parsed_params["list"]}&index=#{video_index}&start=#{video_time}&autoplay=1"
        parsed_params["v"] ->
          "#{parsed_video}#{parsed_params["v"]}?start=#{video_time}&autoplay=1"
        true ->
          ""
      end
  end
end
