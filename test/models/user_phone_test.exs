defmodule AwesomeApp.UserPhoneTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.UserPhone

  @valid_attrs %{is_primary: true, number: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserPhone.changeset(%UserPhone{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserPhone.changeset(%UserPhone{}, @invalid_attrs)
    refute changeset.valid?
  end
end
