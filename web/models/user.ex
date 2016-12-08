defmodule AwesomeApp.User do
  use AwesomeApp.Web, :model

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :name, :string
    field :username, :string
    field :bio, :string

    field :email, :string
    field :email_md5, :string
    field :email_token, Ecto.UUID
    field :email_verified, :boolean

    field :password, :string, virtual: true
    field :password_hash, :string

    field :verified, :boolean

    has_many :phones, AwesomeApp.UserPhone

    timestamps()
  end

  def profile_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :bio])
    |> validate_required([:name, :email])
    |> update_change(:email, &String.downcase/1)
    |> update_email()
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> profile_changeset(params)
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp update_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        changeset
        |> put_change(:email_token, Ecto.UUID.generate())
        |> put_change(:email_md5, md5_hash(email))
        |> put_change(:email_verified, false)
      _ ->
        changeset
    end
  end
end
