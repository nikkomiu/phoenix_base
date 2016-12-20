defmodule PhoenixBase.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :username, :string, null: false
      add :bio, :string
      add :url, :string
      add :company, :string
      add :phone_number, :string
      add :sign_in_count, :integer, null: false, default: 0
      add :unverified_email, :string
      add :verification_token, :uuid
      add :verification_sent_at, :utc_datetime
      add :confirmation_token, :uuid
      add :confirmed_at, :utc_datetime
      add :locked_at, :utc_datetime
      add :unlock_token, :uuid
      add :failed_attempts, :integer, null: false, default: 0

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:username])

    create table(:user_identities) do
      add :provider, :string, null: false
      add :external_uid, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:user_identities, [:user_id])
    create unique_index(:user_identities, [:provider, :external_uid])

    create table(:user_logins) do
      add :encrypted_password, :string, null: false
      add :reset_sent, :utc_datetime
      add :reset_token, :uuid
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:user_logins, [:user_id])
  end
end
