defmodule LiveViewDemoWeb.RoomLive do
  use Phoenix.LiveView
  alias LiveViewDemo.Message
  alias LiveViewDemo.Room

  def render(assigns) do
    LiveViewDemoWeb.RoomView.render("index.html", assigns)
  end

  def mount(%{path_params: %{"room_id" => room}}, socket) do
    if connected?(socket), do: Room.subscribe(room)
    {:ok, fetch(socket, %{username: nil, room: room})}
  end

  def fetch(socket, message) do
    assign(socket, %{
      username: message.username,
      room: message.room,
      messages: Room.messages(message.room),
      changeset: Room.change_message(%Message{username: message.username, room: message.room}),
      video: Room.video(message.room)
    })
  end

  def handle_event("send_message", %{"message" => params}, socket) do
    case Room.process_message(params) do
      {:ok, message} ->
        {:noreply, fetch(socket, message)}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info(_step, socket) do
    room = socket.assigns |> Map.get(:room)
    result = assign(socket, %{ messages: Room.messages(room) })
    {:noreply,  result}
  end
end
