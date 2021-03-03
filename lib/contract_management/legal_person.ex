defmodule ContractManagement.LegalPerson do
  use Ecto.Schema
  import Ecto.Changeset

  alias ContractManagement.Address

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :cnpj]

  schema "legal_person" do
    field :name, :string
    field :cnpj, :string
    has_one :address, Address

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:cnpj, is: 14)
    |> validate_format(:cnpj, ~r/^[0-9]*$/)
    |> unique_constraint([:cnpj])
  end
end
