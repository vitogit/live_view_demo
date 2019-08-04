defmodule LiveViewDemoWeb.RoomLiveTest do
  use LiveViewDemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias LiveViewDemo.Message
  alias LiveViewDemo.Repo

  @message %{username: "Henry", content: "Hello World", room: "e4e5"}
  @message_roll %{username: "Henry", content: "/r 2d6", room: "e4e5"}
  @message_roll_fail %{username: "Henry", content: "/r 51d6", room: "e4e5"}
  @message_roll_fail_faces %{username: "Henry", content: "/r 2d6000", room: "e4e5"}

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

  test "roll the dices", %{conn: conn} do
    {:ok, view, _} = live(conn, "/room/e4e5")
    result = render_submit(view, :send_message, %{ message: @message_roll}) 
    assert result =~ "#{@message_roll.username} rolled 2d6:"
  end

  test "fails when there are more than 50 dices", %{conn: conn} do
    {:ok, view, _} = live(conn, "/room/e4e5")
    result = render_submit(view, :send_message, %{ message: @message_roll_fail}) 
    assert result =~ "Error, too many dices. Try less than 50"
  end

  test "fails when the dices has more than 1000 faces", %{conn: conn} do
    {:ok, view, _} = live(conn, "/room/e4e5")
    result = render_submit(view, :send_message, %{ message: @message_roll_fail_faces}) 
    assert result =~ "Error, the dice has too many faces. Try less than 1000"
  end
end

