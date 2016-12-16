defmodule PhoenixBase.UserStore do
  use PhoenixBase.Web, :model_store

  alias PhoenixBase.User

  def find_by_email(email) do
    Repo.one(from u in User,
      where: u.email == ^email)
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
