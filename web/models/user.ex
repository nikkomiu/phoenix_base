defmodule AwesomeApp.User do
  use AwesomeApp.Web, :model

  import Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :email_md5, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    field :bio, :string

    has_many :phones, AwesomeApp.UserPhone

    timestamps()
  end

  def full_details_by_id(id) do
    Repo.one from u in AwesomeApp.User,
      where: u.id == ^id,
      preload: [:phones]
  end

  def find_by_email_or_username(field) do
    Repo.one from u in AwesomeApp.User,
      where: u.email == ^field or u.username == ^field
  end

  def find_and_confirm_password(email, password) do
    case find_by_email_or_username(email) do
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
    |> cast(params, [:name, :username, :email, :password])
    |> validate_required([:name, :email, :username, :password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash()
    |> put_email_md5()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp put_email_md5(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        put_change(changeset, :email_md5, md5_hash(email |> String.downcase ))
      _ ->
        changeset
    end
  end
end
