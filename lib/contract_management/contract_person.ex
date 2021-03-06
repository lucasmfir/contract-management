defmodule ContractManagement.ContractPerson do
  use Ecto.Schema
  import Ecto.Changeset

  alias ContractManagement.Contract

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params ~w(contract_id person_id person_type)a
  @foreign_key_type :binary_id

  schema "contract_person" do
    field :person_id, :binary_id
    field :person_type, Ecto.Enum, values: [:natural_person, :legal_person]
    belongs_to :contract, Contract

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
