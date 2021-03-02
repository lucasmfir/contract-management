defmodule ContractManagement.Address do
  use Ecto.Schema
  import Ecto.Changeset

  alias ContractManagement.LegalPerson

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :cnpj]

  schema "address" do
    field :country, :string
    field :state, :string
    field :street, :string
    field :zip_code, :string
    belongs_to :legal_person, LegalPerson

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
