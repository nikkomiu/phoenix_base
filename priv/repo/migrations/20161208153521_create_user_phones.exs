defmodule AwesomeApp.Repo.Migrations.CreateUserPhones do
  use Ecto.Migration

  def change do
    create table(:user_phones) do
      add :number, :string
      add :description, :string
      add :is_primary, :boolean, default: false, null: false

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:user_phones, [:user_id])
    create unique_index(:user_phones, [:number])
  end
end
