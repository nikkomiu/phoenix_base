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

user = Repo.insert!(%User{
  name: "Nikko Miu",
  email: "nikko.miu@nikkomiu.com",
  password_hash: "$2b$12$EDYkiwzAD59vBIJ3HU59MOojQgEkLWXQ/KM89Tm5O67Sl3kS17qEm"
})

Repo.insert!(%UserPhone{
  number: "1234567890",
  description: "mobile",
  is_primary: true,
  user_id: user.id
})
