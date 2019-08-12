defmodule LiveViewDemo.RoomTest do
  use LiveViewDemo.DataCase

  alias LiveViewDemo.Room

  describe "messages" do
    alias LiveViewDemo.Message
    @video_attrs %{"playlist"=> "some playlist", "starttime" => "123", "video_index" => "3"}
    @valid_attrs %{content: "some content", room: "some room", username: "some username", video: @video_attrs}
    @invalid_attrs %{content: nil, room: nil, username: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Room.create_message()
      message
    end

    test "message has video field" do
      message = message_fixture()
      assert message.video != nil
    end

    test "messages/1 returns message rooms" do
      message = message_fixture()
      assert Room.messages(message.room) == [message]
      assert Room.messages("other room") == []
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Room.create_message(@valid_attrs)
      assert message.content == "some content"
      assert message.room == "some room"
      assert message.username == "some username"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Room.create_message(@invalid_attrs)
    end

  end
end
