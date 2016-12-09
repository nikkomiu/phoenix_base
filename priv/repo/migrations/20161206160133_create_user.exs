defmodule AwesomeApp.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true

      # Authentication
      add :email, :string, null: false
      add :encrypted_password, :string

      # User Info
      add :name, :string, null: false
      add :username, :string, null: false
      add :bio, :string

      # Recovery
      add :reset_password_token, :uuid
      add :reset_password_sent_at, :datetime

      # Tracking
      add :sign_in_count, :integer, default: 0, null: false

      # Confirmation
      add :confirmation_token, :uuid
      add :confirmed_at, :datetime
      add :confirmation_sent_at, :datetime
      add :unconfirmed_email, :string

      # Locking
      add :failed_attempts, :integer, default: 0, null: false
      add :unlock_token, :string
      add :locked_at, :datetime

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
