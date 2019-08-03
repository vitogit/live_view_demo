defmodule LiveViewDemoWeb.RoomLive do
  use Phoenix.LiveView
  alias LiveViewDemo.Message
  alias LiveViewDemo.Room
  def render(assigns) do
    ~L"""
      <div class="row">
        <div class="column">
        </div>
        <div class="column column-70">
          <ul id="msgs" style="list-style: none; height:300px; border: 1px solid; padding: 10px;overflow:auto">
            <%= for msg <- @messages do %>
                <li><strong> <%= msg.username %> : </strong> <%= msg.content %> </li>
            <% end %>
          </ul>
        </div>
      </div>
    """
  end

  def mount(%{path_params: %{"room_id" => room}}, socket) do
    if connected?(socket), do: Room.subscribe(room)
    {:ok, fetch(socket, nil, room)}
  end

  def fetch(socket, username \\ nil, room) do
    assign(socket, %{
      username: username,
      messages: Room.messages(room),
      changeset: Room.change_message(%Message{username: username, room: room}),
      room: room
    })
  end
end
