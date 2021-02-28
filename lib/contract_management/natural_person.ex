defmodule ContractManagement.NaturalPerson do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :cpf, :birth_date]

  schema "natural_person" do
    field :name, :string
    field :cpf, :string
    field :birth_date, :date

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:cpf, is: 11)
    |> validate_format(:cpf, ~r/^[0-9]*$/)
    |> unique_constraint([:cpf])
  end
end
