# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AwesomeApp.Repo.insert!(%AwesomeApp.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AwesomeApp.Repo
alias AwesomeApp.User
alias AwesomeApp.UserPhone

defmodule SeedHelpers do
  import Ecto.Query

  def find_or_create(klass, field, %Ecto.Changeset{valid?: true} = changeset) do
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

{:ok, uid} = Ecto.UUID.cast("661f4979-d1cb-470e-993d-756119d12ebd")

user = SeedHelpers.find_or_create(User, :username,
  User.registration_changeset(%User{id: uid, confirmed_at: Ecto.DateTime.from_erl(:calendar.universal_time)}, %{
    name: "Nikko Miu",
    username: "nikko.miu",
    email: "nikkoamiu@gmail.com",
    password: "Password1"
  })
)

SeedHelpers.find_or_create(UserPhone, :number,
  %UserPhone{
    number: "1234567890",
    description: "mobile",
    is_primary: true,
    user_id: user.id
  }
)
