defmodule PhoenixBase.User do
  use PhoenixBase.Web, :model

  @derive {Phoenix.Param, key: :username}

  @max_login_attempts 3

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :bio, :string
    field :url, :string
    field :company, :string
    field :phone_number, :string
    field :sign_in_count, :integer
    field :unverified_email, :string
    field :verification_token, Ecto.UUID
    field :verification_sent_at, Ecto.DateTime
    field :confirmation_token, Ecto.UUID
    field :confirmed_at, Ecto.DateTime
    field :locked_at, Ecto.DateTime
    field :unlock_token, Ecto.UUID
    field :failed_attempts, :integer

    has_one :user_login, PhoenixBase.UserLogin
    has_many :user_identities, PhoenixBase.UserIdentity

    timestamps()
  end

  def profile_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :bio, :url, :company, :phone_number, :unverified_email])
    |> validate_required([:name])
  end

  def login_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:failed_attempts, :sign_in_count])
    |> validate_required([:failed_attempts])
    |> should_lock_account()
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :username, :email])
    |> validate_required([:name, :username, :email])
    |> validate_format(:username, ~r/^[a-zA-Z0-9\.\-\_]*$/)
  end

  def verify_email_changeset(%PhoenixBase.User{unverified_email: new_email} = user) do
    user
    |> put_change(:email, new_email)
    |> put_change(:unverified_email, nil)
  end

  defp should_lock_account(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{failed_attempts: attempts}} ->
        if attempts >= @max_login_attempts do
          changeset
          |> put_change(:locked_at, Ecto.DateTime.utc)
          |> put_change(:unlock_token, Ecto.UUID.generate())
        else
          changeset
        end
      _ ->
        changeset
    end
  end
end
