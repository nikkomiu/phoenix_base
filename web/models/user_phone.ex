defmodule AwesomeApp.UserPhone do
  use AwesomeApp.Web, :model

  schema "user_phones" do
    field :number, :string
    field :description, :string
    field :is_primary, :boolean, default: false

    belongs_to :user, AwesomeApp.User, type: Ecto.UUID

    timestamps()
  end

  def description_options() do
    ["main", "home", "mobile", "work", "other"]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number, :is_primary])
    |> validate_required([:number, :is_primary])
    |> validate_inclusion(:description, description_options)
  end
end
