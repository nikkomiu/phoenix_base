defmodule AwesomeApp.UserLoginTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.UserLogin

  @valid_attrs %{encrypted_password: "some content", failed_attempts: 42, locked_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, reset_sent: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, reset_token: "7488a646-e31f-11e4-aace-600308960662", unlock_token: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserLogin.changeset(%UserLogin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserLogin.changeset(%UserLogin{}, @invalid_attrs)
    refute changeset.valid?
  end
end
