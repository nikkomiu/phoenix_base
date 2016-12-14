defmodule AwesomeApp.UserIdentity do
  use AwesomeApp.Web, :model

  schema "user_identities" do
    field :provider, :string
    field :external_uid, :string
    belongs_to :user, AwesomeApp.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:provider, :external_uid])
    |> validate_required([:provider, :external_uid])
  end
end
