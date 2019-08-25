defmodule LiveViewDemoWeb.RoomLive do
  use Phoenix.LiveView
  alias LiveViewDemo.Message
  alias LiveViewDemo.Room

  def render(assigns) do
    LiveViewDemoWeb.RoomView.render("index.html", assigns)
  end

  def mount(%{path_params: %{"room_id" => room}}, socket) do
    if connected?(socket), do: Room.subscribe(room)
    {:ok, fetch_messages(socket, %{room: room, username: ""})}
  end

  # TODO keep the video going when adding new message
  def fetch_messages(socket, message) do
    video = Room.last_video(message.room) || socket.assigns[:video] || ""
    assign(socket, %{
      username: socket.assigns[:username] || message.username,
      room: message.room,
      messages: Room.messages(message.room),
      changeset: Room.change_message(%Message{username: message.username, room: message.room, video: video}),
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
end
