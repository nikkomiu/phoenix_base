defmodule AwesomeApp.User do
  use AwesomeApp.Web, :model

  import Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :user_phones, AwesomeApp.UserPhone

    timestamps()
  end

  def find_by_email(email) do
    Repo.one from u in AwesomeApp.User,
      where: u.email == ^email
  end

  def find_and_confirm_password(email, password) do
    case find_by_email(email) do
      nil ->
        { dummy_checkpw, nil }
      user ->
        { checkpw(password, user.password_hash), user }
    end
  end

  def session_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:password])
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
end
