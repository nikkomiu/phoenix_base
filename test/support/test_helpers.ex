defmodule AwesomeApp.TestHelpers do
  alias AwesomeApp.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Test User",
      username: "user_#{Base.encode16(:crypto.rand_bytes(8))}",
      email: "test.user@nikkomiu.com",
      password: "rightstuff"
    }, attrs)

    %AwesomeApp.User{}
    |> AwesomeApp.User.registration_changeset(changes)
    |> Repo.insert!()
  end
end
