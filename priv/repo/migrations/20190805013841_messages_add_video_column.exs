defmodule LiveViewDemo.Repo.Migrations.MessagesAddVideoColumn do
  use Ecto.Migration

  def change do
    alter table("messages") do
      add :video, :map, default: "{}"
    end
  end
end
