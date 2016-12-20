defmodule PhoenixBase.UserTest do
  use PhoenixBase.ModelCase

  # Login Changeset
  describe "login_changeset/2" do
    test "login changeset sets failed attempts"

    test "login changeset locks out after too many attempts"

    test "login changeset increments sign in count after successful attempt"

    test "login changeset does not increment sign in count after failed attempt"
  end

  describe "registration_changeset/2" do

  end

  describe "locking_changeset/2" do

  end

  describe "profile_changeset/2" do

  end

  describe "email_changeset/2" do

  end

  describe "verify_email_changeset/1" do

  end

  describe "unlock_account_changeset/1" do

  end
end
