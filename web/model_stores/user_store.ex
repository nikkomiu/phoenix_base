defmodule AwesomeApp.UserStore do
  use AwesomeApp.Web, :model_store

  alias AwesomeApp.User

  def find_by_id(id) do
    Repo.one(from u in User,
      where: u.id == ^id)
  end

  def find_by_username(username) do
    Repo.one(from u in User,
      where: u.username == ^username)
  end

  def find_by_username_or_email(field) do
    Repo.one from u in User,
      where: u.username == ^field or u.email == ^field,
      preload: [:user_login, :user_identities]
  end
end
