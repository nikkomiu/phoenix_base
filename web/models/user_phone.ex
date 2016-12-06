defmodule AwesomeApp.UserPhone do
  use AwesomeApp.Web, :model

  schema "user_phones" do
    field :number, :string
    field :description, :string
    field :is_primary, :boolean, default: false
    
    belongs_to :user, AwesomeApp.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number, :is_primary])
    |> validate_required([:number, :is_primary])
    |> unique_constraint(:number)
  end
end
