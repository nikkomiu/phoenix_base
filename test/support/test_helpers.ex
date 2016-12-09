defmodule AwesomeApp.TestHelpers do
  alias AwesomeApp.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Test User",
      username: "user_#{Base.encode16(:crypto.rand_bytes(8))}",
      email: "test.user@nikkomiu.com",
      password: "rightstuff",
      password_confirmation: "rightstuff",
      confirmed_at: Ecto.DateTime.from_erl(:calendar.universal_time)
    }, attrs)

    %AwesomeApp.User{}
    |> AwesomeApp.User.registration_changeset(changes)
    |> AwesomeApp.User.locking_changeset(changes)
    |> Repo.insert!()
  end
end
