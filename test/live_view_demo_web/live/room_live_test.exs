defmodule LiveViewDemoWeb.RoomLiveTest do
  use LiveViewDemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias LiveViewDemo.Message
  alias LiveViewDemo.Repo

  @message %{username: "Henry", content: "Hello World", room: "e4e5"}

  test "load room page", %{conn: conn} do
    {:ok, _, html} = live(conn, "/room/e4e5")
    assert html =~ "id=\"msgs\""
  end

  test "show message list", %{conn: conn} do
    %Message{} |> Message.changeset(@message) |> Repo.insert()
    {:ok, _, html} = live(conn, "/room/e4e5")
    assert html =~ "Hello World"
  end

  test "show form", %{conn: conn} do
    {:ok, _, html} = live(conn, "/room/e4e5")
    assert html =~ "form accept-charset"
  end

  test "sends a message", %{conn: conn} do
    {:ok, view, _} = live(conn, "/room/e4e5")
    result = render_submit(view, :send_message, %{ message: @message}) 
    assert result =~ "Hello World"
  end
end

