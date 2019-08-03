defmodule LiveViewDemo.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :username, :string
      add :content, :text
      add :room, :string

      timestamps()
    end

  end
end
