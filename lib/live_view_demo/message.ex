defmodule LiveViewDemo.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :room, :string
    field :username, :string
    field :video, :string
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:username, :content, :room, :video])
    |> validate_required([:username, :content, :room])
  end
end
