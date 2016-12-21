defmodule PhoenixBase.TestHelpers do
  alias PhoenixBase.Repo
  alias PhoenixBase.User
  alias PhoenixBase.UserLogin

  def insert_user(attrs \\ %{}) do
    rand = Base.encode16(:crypto.strong_rand_bytes(8))
    changes = Dict.merge(%{
      name: "Test User",
      username: "user_#{rand}",
      email: "test.user_#{rand}@nikkomiu.com",
      confirmed_at: Ecto.DateTime.utc()
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> User.locking_changeset(changes)
    |> Repo.insert!()
  end

  def insert_user_login(%User{} = user, attrs \\ %{}) do
    changes = Dict.merge(%{
      password: "P@ssword1",
      password_confirmation: "P@ssword1"
    }, attrs)

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(changes)

    if attrs[:should_reset] == true do
      changeset
      |> UserLogin.reset_token_changeset()
    else
      changeset
    end
    |> Repo.insert!
  end

  def find_user_login_by_id(id) do
    Repo.get(UserLogin, id)
  end
end
