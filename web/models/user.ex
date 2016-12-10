defmodule AwesomeApp.User do
  use AwesomeApp.Web, :model

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  @max_login_attempts 5

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string

    field :name, :string
    field :username, :string
    field :bio, :string

    field :reset_password_token, Ecto.UUID
    field :reset_password_sent_at, Ecto.UUID

    field :sign_in_count, :integer

    field :confirmation_token, Ecto.UUID
    field :confirmed_at, Ecto.DateTime
    field :confirmation_sent_at, Ecto.DateTime
    field :unconfirmed_email, :string

    field :failed_attempts, :integer
    field :unlock_token, :string
    field :locked_at, Ecto.DateTime

    has_many :phones, AwesomeApp.UserPhone

    timestamps()
  end

  def login_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:sign_in_count, :failed_attempts])
    |> should_account_get_locked
  end

  def locking_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:locked_at, :confirmed_at])
    |> confirm_email
  end

  def email_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:confirmation_sent_at, :reset_password_sent_at])
  end

  def profile_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :bio])
    |> validate_required([:name])
    |> update_change(:email, &String.downcase/1)
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> profile_changeset(params)
    |> cast(params, [:email, :username, :password, :password_confirmation])
    |> validate_required([:email, :username, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_password_requirements
    |> put_encrypted_password
    |> put_confirmation_token
  end

  def update_registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:unconfirmed_email, :username, :password, :password_confirmation])
    |> validate_username_requirements
    |> validate_password_if_changed
    |> put_encrypted_password
    |> put_confirmation_token
  end

  defp validate_password_if_changed(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: _}} ->
        changeset
        |> validate_password_requirements
        |> validate_confirmation(:password)
      _ ->
        changeset
    end
  end

  defp validate_password_requirements(changeset) do
    changeset
    |> validate_length(:password, min: 6, max: 100)
  end

  defp validate_username_requirements(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{username: _}} ->
        changeset
        |> validate_format(:username, ~r/^[a-zA-Z0-9-_]*$/,
            message: "can only contain alphanumeric characters, underscores, and hyphens")
      _ ->
        changeset
    end
  end

  defp put_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp put_confirmation_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        changeset
        |> put_change(:confirmation_token, Ecto.UUID.generate())
      _ ->
        changeset
    end
  end

  defp confirm_email(changeset) do
    case changeset do
      # Confirm new account
      %Ecto.Changeset{valid?: true, data: %{unconfirmed_email: nil}, changes: %{confirmed_at: _}} ->
        changeset
      # Confirm new email
      %Ecto.Changeset{valid?: true, data: %{unconfirmed_email: u_email}, changes: %{confirmed_at: _}} ->
        changeset
        |> put_change(:email, u_email)
        |> put_change(:unconfirmed_email, nil)
      _ ->
        changeset
    end
  end

  defp should_account_get_locked(changeset) do
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
