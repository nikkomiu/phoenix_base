defmodule AwesomeApp.User do
  use AwesomeApp.Web, :model

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :name, :string
    field :username, :string
    field :bio, :string

    field :unverified_email, :string
    field :email, :string
    field :email_token, Ecto.UUID
    field :email_verified, :boolean

    field :password, :string, virtual: true
    field :password_hash, :string

    field :login_attempts, :integer
    field :locked, :boolean
    field :number_of_logins, :integer

    has_many :phones, AwesomeApp.UserPhone

    timestamps()
  end

  def login_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:number_of_logins, :login_attempts])
  end

  def locking_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:locked, :email_verified])
  end

  def profile_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :bio])
    |> validate_required([:name, :email])
    |> update_change(:email, &String.downcase/1)
    |> put_email_token()
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

  defp put_email_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        changeset
        |> put_change(:email_token, Ecto.UUID.generate())
        |> put_change(:email_verified, false)
      _ ->
        changeset
    end
  end
end
