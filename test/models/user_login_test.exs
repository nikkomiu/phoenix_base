defmodule PhoenixBase.UserLoginTest do
  use PhoenixBase.ModelCase

  alias Ecto.Changeset
  alias PhoenixBase.UserLogin
  alias PhoenixBase.TestHelpers

  @valid_attrs %{password: "S0meP@ssword", password_confirmation: "S0meP@ssword"}

  setup do
    user = TestHelpers.insert_user()

    {:ok, %{user: user}}
  end

  test "registration set encrypted password when valid", %{user: user} do
    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(@valid_attrs)

    assert changeset.valid?
  end

  test "registration error on password mismatch", %{user: user} do
    attrs = Map.put(@valid_attrs, :password_confirmation, "Not1MyP@ss")

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password_confirmation, "Does not match confirmation"} in errors_on(changeset)
  end

  test "registration error on no password", %{user: user} do
    attrs = Map.put(@valid_attrs, :password, nil)

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password, "Can't be blank"} in errors_on(changeset)
  end

  test "registration error on no password confirmation", %{user: user} do
    attrs = Map.put(@valid_attrs, :password_confirmation, nil)

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password_confirmation, "Can't be blank"} in errors_on(changeset)
  end

  test "registration error on password too short", %{user: user} do
    attrs = Map.merge(@valid_attrs, %{password: "some", password_confirmation: "some"})

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password, "Should be at least 8 character(s)"} in errors_on(changeset)
  end

  test "registration error on password without lower letter", %{user: user} do
    attrs = Map.merge(@valid_attrs, %{password: "SOME@PASS1", password_confirmation: "SOME@PASS1"})

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password, "Must contain a lowercase letter"}
      in errors_on(changeset)
  end

  test "registration error on password without uppercase letter", %{user: user} do
    attrs = Map.merge(@valid_attrs, %{password: "some@pass1", password_confirmation: "some@pass1"})

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password, "Must contain a capital letter"}
      in errors_on(changeset)
  end

  test "registration error on password without number", %{user: user} do
    attrs = Map.merge(@valid_attrs, %{password: "Some@Pass", password_confirmation: "Some@Pass"})

    changeset =
      user
      |> Ecto.build_assoc(:login)
      |> UserLogin.registration_changeset(attrs)

    assert {:password, "Must contain a number"}
      in errors_on(changeset)
  end

  test "should set reset sent on email changeset" do
    changeset = UserLogin.email_changeset(%UserLogin{}, %{reset_sent: Ecto.DateTime.utc})

    assert Changeset.get_change(changeset, :reset_sent) != nil
  end

  test "should set reset token on reset token changeset" do
    changeset = UserLogin.reset_token_changeset(%UserLogin{})

    assert Changeset.get_change(changeset, :reset_token) != nil
  end

  test "should not set reset token if one exists on reset token changeset" do
    token = Ecto.UUID.generate
    changeset = UserLogin.reset_token_changeset(%UserLogin{reset_token: token})

    assert Changeset.get_field(changeset, :reset_token) == token
  end
end
