defmodule LiveViewDemoWeb.MainLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h3> Welcome to Roll & Music Together <h3>
    <p> We just generated a random room for you and your party. 
    Enter the link and share it with your friends so you can chat, roll dices and listen to the same song together. 
    </p>
    <blockquote>
      <a href='/room/<%= @random_room %>'>  <%= @random_room %>  </a>
    </blockquote>
    
    <br>
    <p>
    Remember that anyone with the link can access so don't share too much :)
    </p>
    """
  end

  def mount(_session, socket) do
    {:ok, generate_random_room(socket)}
  end

  defp generate_random_room(socket) do
    random_room = Ecto.UUID.generate |> URI.encode
    assign(socket, :random_room,  random_room)
  end
end
