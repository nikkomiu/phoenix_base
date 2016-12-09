defmodule AwesomeApp.UserTest do
  use AwesomeApp.ModelCase

  alias AwesomeApp.User

  @valid_registration_attrs %{
    name: "Test User",
    username: "test.user",
    email: "test.user@nikkomiu.com",
    password: "testPassword1",
    password_confirmation: "testPassword1"
  }

  test "should register with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)

    assert changeset.valid?
  end

  test "should not register without name" do
    changeset = User.registration_changeset(%User{}, merge_params(name: nil))

    assert {:name, {"can't be blank", []}} in changeset.errors
  end

  test "should not register without username" do
    changeset = User.registration_changeset(%User{}, merge_params(username: nil))

    assert {:username, {"can't be blank", []}} in changeset.errors
  end

  test "should not register without password" do
    changeset = User.registration_changeset(%User{}, merge_params(password: nil, password_confirmation: nil))

    assert {:password, {"can't be blank", []}} in changeset.errors
  end

  test "should not register without password confirmation" do
    changeset = User.registration_changeset(%User{}, merge_params(password_confirmation: nil))

    assert {:password_confirmation, {"can't be blank", []}} in changeset.errors
  end

  test "should not register with password confirmation mismatch" do
    changeset = User.registration_changeset(%User{},
      merge_params(password: "somethingAwesome1", password_confirmation: "somethingElse"))

    assert {:password_confirmation, {"does not match confirmation", []}} in changeset.errors
  end

  test "should store confirmation token on registration" do
    changeset = User.registration_changeset(%User{}, merge_params)

    refute %{confirmation_token: nil} in changeset.changes
  end

  test "should store encrypted password on registration" do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)

    refute %{encrypted_password: nil} in changeset.changes
  end

  test "should not update password when confirmation does not match" do
    changeset = User.update_registration_changeset(%User{}, %{
      password: "testingPassword1",
      password_confirmation: "SomeOtherPass"
    })

    assert {:password_confirmation, {"does not match confirmation", []}} in changeset.errors
  end

  test "should store encrypted password on password change" do
    pass = "somePassword1"
    old_enc_pas = "someoldencryptedpassword"

    changeset = User.update_registration_changeset(%User{encrypted_password: old_enc_pas}, %{
      password: pass,
      password_confirmation: pass
    })

    assert changeset.changes.encrypted_password != old_enc_pas
  end

  test "should update username" do
    new_username = "new_awesome_username"

    changeset = User.update_registration_changeset(%User{},
      %{username: new_username})

    assert changeset.changes.username == new_username
  end

  test "should add unconfirmed email" do
    changeset = User.update_registration_changeset(%User{},
      %{unconfirmed_email: "test@test.com"})

    assert changeset.changes.unconfirmed_email == "test@test.com"
  end

  test "should confirm a new email" do
    time = Ecto.DateTime.from_erl(:calendar.universal_time)
    new_email = "test@test.com"

    changeset = User.locking_changeset(%User{email: "notthis@test.com",
      unconfirmed_email: new_email}, %{confirmed_at: time})

    assert changeset.changes.confirmed_at == time
    assert changeset.changes.unconfirmed_email == nil
    assert changeset.changes.email == new_email
  end

  test "should not allow special characters in username" do
    changeset = User.update_registration_changeset(%User{},
      %{username: "som@!username#"})

    assert {:username, {"can only contain alphanumeric characters, underscores, and hyphens", []}} in changeset.errors
  end

  test "should lock account after too many login attempts" do
    changeset = User.login_changeset(%User{failed_attempts: 4}, %{failed_attempts: 5})

    assert changeset.changes.locked_at != nil
  end

  test "should set unlock token after too many login attempts" do
    changeset = User.login_changeset(%User{failed_attempts: 4}, %{failed_attempts: 5})

    assert changeset.changes.unlock_token != nil
  end

  test "should unlock account" do
    changeset = User.locking_changeset(%User{locked_at: Ecto.DateTime.utc}, %{locked_at: nil})

    assert changeset.changes.locked_at == nil
  end

  test "should confirm account" do
    time = Ecto.DateTime.utc
    changeset = User.locking_changeset(%User{}, %{confirmed_at: time})

    assert changeset.changes.confirmed_at == time
  end

  defp merge_params(attrs \\ %{}) do
    Dict.merge(@valid_registration_attrs, attrs)
  end
end
