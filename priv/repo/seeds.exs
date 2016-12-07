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

user = Repo.insert!(User.registration_changeset(%User{}, %{
  name: "Nikko Miu",
  username: "nikko.miu",
  email: "nikkoamiu@gmail.com",
  password: "Password1"
}))

Repo.insert!(%UserPhone{
  number: "1234567890",
  description: "mobile",
  is_primary: true,
  user_id: user.id
})
