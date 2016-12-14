defmodule AwesomeApp.UserIdentityTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.UserIdentity

  @valid_attrs %{external_uid: "some content", provider: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserIdentity.changeset(%UserIdentity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserIdentity.changeset(%UserIdentity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
