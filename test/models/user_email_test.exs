defmodule AwesomeApp.UserEmailTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.UserEmail

  @valid_attrs %{email: "some content", is_primary: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserEmail.changeset(%UserEmail{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserEmail.changeset(%UserEmail{}, @invalid_attrs)
    refute changeset.valid?
  end
end
