defmodule PhoenixBase.TestHelpers do
  alias PhoenixBase.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Test User",
      username: "user_#{Base.encode16(:crypto.rand_bytes(8))}",
      email: "test.user@nikkomiu.com",
      password: "rightstuff",
      password_confirmation: "rightstuff",
      confirmed_at: Ecto.DateTime.from_erl(:calendar.universal_time)
    }, attrs)

    %PhoenixBase.User{}
    |> PhoenixBase.User.registration_changeset(changes)
#    |> PhoenixBase.User.locking_changeset(changes)
    |> Repo.insert!()
  end

  def insert_user_login(user_id, attrs \\ %{}) do
    changes = Dict.merge(%{
      password: "Password1",
      password_confirmation: "Password1"
    })
  end
end
