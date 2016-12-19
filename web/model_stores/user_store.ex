defmodule PhoenixBase.UserStore do
  use PhoenixBase.Web, :model_store

  alias PhoenixBase.User

  @moduledoc false

  def find_by_id(id) do
    Repo.one(from u in User,
      where: u.id == ^id,
      preload: [:login])
  end

  def find_by_email(email) do
    Repo.one(from u in User,
      where: u.email == ^email,
      preload: [:login])
  end

  def find_by_username(username) do
    Repo.one(from u in User,
      where: u.username == ^username)
  end

  def find_by_username_or_email(field) do
    Repo.one from u in User,
      where: u.username == ^field or u.email == ^field,
      preload: [:login]
  end

  def find_user_login_by_reset_token(token) do
    Repo.one from l in PhoenixBase.UserLogin,
      where: l.reset_token == ^token,
      preload: [:user]
  end
end
