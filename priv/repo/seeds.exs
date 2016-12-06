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

AwesomeApp.Repo.insert!(%AwesomeApp.User{
  name: "Nikko Miu",
  email: "nikko.miu@nikkomiu.com",
  password_hash: "$2b$12$EDYkiwzAD59vBIJ3HU59MOojQgEkLWXQ/KM89Tm5O67Sl3kS17qEm"
})
