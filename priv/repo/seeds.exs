# Script for populating the database. You can run it as:
#   mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#   PhoenixBase.Repo.insert!(%PhoenixBase.SomeModel{})

alias Ecto.Changeset
alias PhoenixBase.Repo
alias PhoenixBase.User
alias PhoenixBase.UserLogin

defmodule SeedHelpers do
  import Ecto.Query

  def find_or_create(klass, field, %Changeset{} = changeset) do
    (from x in klass,
      where: field(x, ^field) == ^Changeset.get_field(changeset, field, nil))
    |> find_or_create(changeset)
  end

  def find_or_create(klass, field, model) do
    (from x in klass,
      where: field(x, ^field) == ^Map.get(model, field))
    |> find_or_create(model)
  end

  defp find_or_create(query, changeset) do
    Repo.one(query) || Repo.insert!(changeset)
  end
end

user = SeedHelpers.find_or_create(User, :username,
  User.registration_changeset(%User{confirmed_at: Ecto.DateTime.utc}, %{
    name: "Nikko Miu",
    email: "nikkoamiu@gmail.com",
    username: "nikko.miu"
  })
)

SeedHelpers.find_or_create(UserLogin, :user_id,
  UserLogin.registration_changeset(%UserLogin{user_id: user.id}, %{
    password: "P@ssword1",
    password_confirmation: "P@ssword1",
  })
)
