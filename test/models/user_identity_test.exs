defmodule PhoenixBase.UserIdentityTest do
  use PhoenixBase.ModelCase

  alias PhoenixBase.UserIdentity

  @valid_attrs %{external_uid: "some content", provider: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes"
  test "changeset with invalid attributes"
end
