defmodule PhoenixBase.UserLogin do
  use PhoenixBase.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias Ecto.UUID

  @moduledoc false

  @max_login_attempts 3

  schema "user_logins" do
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string
    field :reset_sent, Ecto.DateTime
    field :reset_token, Ecto.UUID

    belongs_to :user, PhoenixBase.User

    timestamps()
  end

  def email_changeset(user_login, params \\ %{}) do
    user_login
    |> cast(params, [:reset_sent])
  end

  def reset_token_changeset(user_login) do
    user_login
    |> cast(%{}, [:reset_token])
    |> put_reset_token()
  end

  def registration_changeset(user_login, params \\ %{}) do
    user_login
    |> cast(params, [:user_id, :password, :password_confirmation])
    |> validate_required([:user_id, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> put_encrypted_password()
  end

  defp put_reset_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        if get_field(changeset, :reset_token) do
          changeset
        else
          put_change(changeset, :reset_token, UUID.generate)
        end
      _ ->
        changeset
    end
  end

  defp put_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
