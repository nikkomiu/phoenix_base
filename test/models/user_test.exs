defmodule AwesomeApp.UserTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.User

  @valid_attrs %{bio: "some content", company: "some content", confirmation_token: "7488a646-e31f-11e4-aace-600308960662", confirmed_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, email: "some content", name: "some content", phone_number: "some content", sign_in_count: 42, url: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
