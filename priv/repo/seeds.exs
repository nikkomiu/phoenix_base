# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixBase.Repo.insert!(%PhoenixBase.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixBase.Repo
alias PhoenixBase.User
alias PhoenixBase.UserLogin

defmodule SeedHelpers do
  import Ecto.Query

  def find_or_create(klass, field, %Ecto.Changeset{valid?: _} = changeset) do
    q =
      from x in klass,
        where: field(x, ^field) == ^Ecto.Changeset.get_change(changeset, field, nil)

    find_or_create(q, changeset)
  end

  def find_or_create(klass, field, model) do
    q=
      from x in klass,
        where: field(x, ^field) == ^Map.get(model, field)

    find_or_create(q, model)
  end

  defp find_or_create(query, changeset) do
    Repo.one(query) || Repo.insert!(changeset)
  end
end

user = SeedHelpers.find_or_create(User, :username,
  User.registration_changeset(%User{}, %{
    name: "Nikko Miu",
    email: "nikkoamiu@gmail.com",
    username: "nikko.miu"
  })
)

SeedHelpers.find_or_create(UserLogin, :user_id,
  UserLogin.registration_changeset(%UserLogin{}, %{
    password: "Password1",
    password_confirmation: "Password1",
    user_id: user.id
  })
)
