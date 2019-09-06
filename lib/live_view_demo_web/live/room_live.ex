defmodule LiveViewDemoWeb.RoomLive do
  use Phoenix.LiveView
  alias LiveViewDemo.Message
  alias LiveViewDemo.Room

  def render(assigns) do
    LiveViewDemoWeb.RoomView.render("index.html", assigns)
  end

  def mount(%{path_params: %{"room_id" => room}}, socket) do
    if connected?(socket), do: Room.subscribe(room)
    {:ok, fetch_messages(socket, %{room: room, username: "", video: ""})}
  end

  def fetch_messages(socket, message) do
    video = Room.last_video(message.room) || socket.assigns[:video] || ""
    assign(socket, %{
      username: socket.assigns[:username] || message.username,
      room: message.room,
      messages: Room.messages(message.room),
      changeset: Room.change_message(%Message{username: message.username, room: message.room, video: nil }),
      video: video
    })
  end

  def fetch_video(socket, video) do
    assign(socket, %{
      video: video
    })
  end
  
  def handle_event("send_message", %{"message" => params}, socket) do
    case Room.process_message(params) do
      {:ok, message} ->
        {:noreply, fetch_messages(socket, message)}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("join_room", %{"message" => params}, socket) do
    {:noreply, assign(socket, username: params["username"])}
  end

  def handle_info(_step, socket) do
    room = socket.assigns[:room]
    result = assign(socket, %{ messages: Room.messages(room), video: Room.last_video(room) })
    {:noreply,  result}
  end

  def handle_event("play_video", _, socket) do
    player_action("autoplay=0", "autoplay=1", "Played the video", socket)
  end

  def handle_event("stop_video", _, socket) do
    player_action("autoplay=1", "autoplay=0", "Stopped the video", socket)
  end

  def handle_event("next_video", _, socket) do
    new_video = socket.assigns[:video]
    index_string = URI.parse(new_video).query |> URI.decode_query |> Map.get("index")
    index =  if index_string, do: String.to_integer(index_string), else: 0
    player_action("index=#{index}", "index=#{index+1}", "Playing the next video, index: #{index+1}", socket)
  end

  def handle_event("prev_video", _, socket) do
    new_video = socket.assigns[:video]
    index_string = URI.parse(new_video).query |> URI.decode_query |> Map.get("index")
    index =  if index_string, do: String.to_integer(index_string), else: 0
    player_action("index=#{index}", "index=#{index-1}", "Playing the prev video, index:#{index-1} ", socket)
  end

  def player_action(origin_string, replace_string, message_string, socket) do
    new_video = socket.assigns[:video]
    if (socket.assigns[:video] && socket.assigns[:video] != "" ) do
      new_video = String.replace(socket.assigns[:video], origin_string, replace_string)
      Room.create_message( %{room: socket.assigns[:room], username: socket.assigns[:username], content: message_string, video: new_video } )
    end
    {:noreply, assign(socket, video: new_video) }
  end
end
