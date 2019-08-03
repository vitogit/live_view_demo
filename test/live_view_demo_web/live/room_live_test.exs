defmodule LiveViewDemoWeb.RoomLiveTest do
  use LiveViewDemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias LiveViewDemo.Message
  alias LiveViewDemo.Room
  alias LiveViewDemo.Repo

  @message %{username: "Henry", content: "Hello World", room: "e4e5"}

  test "load room page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/room/xxx")
    assert html =~ "id=\"msgs\""
  end

  test "show message list", %{conn: conn} do
    %Message{} |> Message.changeset(@message) |> Repo.insert()
    {:ok, view, html} = live(conn, "/room/e4e5")
    assert html =~ "Hello World"
  end
end

