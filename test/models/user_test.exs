defmodule AwesomeApp.UserTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.User

  @valid_registration_attrs %{
    name: "Test User",
    username: "test.user",
    email: "test.user@nikkomiu.com",
    password: "testPassword1"
  }
  @invalid_attrs %{}

  test "register with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)
    assert changeset.valid?
  end

  test "register with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
