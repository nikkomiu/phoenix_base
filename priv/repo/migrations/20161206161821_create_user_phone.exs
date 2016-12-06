defmodule AwesomeApp.Repo.Migrations.CreateUserPhone do
  use Ecto.Migration

  def change do
    create table(:user_phones) do
      add :number, :string
      add :description, :string
      add :is_primary, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:user_phones, [:number])
    create index(:user_phones, [:user_id])
  end
end
