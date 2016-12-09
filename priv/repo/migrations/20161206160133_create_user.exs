defmodule AwesomeApp.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :name, :string, null: false
      add :username, :string, null: false
      add :bio, :string

      add :unverified_email, :string
      add :email, :string, null: false
      add :email_token, :uuid, null: false
      add :email_verified, :boolean, default: false, null: false

      add :password_hash, :string

      add :login_attempts, :integer, default: 0, null: false
      add :locked, :boolean, default: true
      add :number_of_logins, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
