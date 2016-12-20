defmodule PhoenixBase.TestHelpers do
  alias PhoenixBase.Repo
  alias PhoenixBase.User
  alias PhoenixBase.UserLogin

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Test User",
      username: "user_#{Base.encode16(:crypto.rand_bytes(8))}",
      email: "test.user@nikkomiu.com",
      confirmed_at: Ecto.DateTime.utc()
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> User.locking_changeset(changes)
    |> Repo.insert!()
  end

  def insert_user_login(%User{} = user, attrs \\ %{}) do
    changes = Dict.merge(%{
      password: "Password1",
      password_confirmation: "Password1"
    }, attrs)

    user
    |> Ecto.build_assoc(:login)
    |> UserLogin.registration_changeset(changes)
    |> Repo.insert!()
  end
end
