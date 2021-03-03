defmodule ContractManagement.Contract do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :file, :description, :date]
  @foreign_key_type :binary_id

  schema "contract" do
    field :name, :string
    field :file, :binary
    field :description, :string
    field :date, :date

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
