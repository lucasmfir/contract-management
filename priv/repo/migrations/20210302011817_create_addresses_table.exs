defmodule ContractManagement.Repo.Migrations.CreateAddressTable do
  use Ecto.Migration

  def change do
    create table(:address) do
      add(:country, :string)
      add(:state, :string)
      add(:city, :string)
      add(:street, :string)
      add(:zip_code, :string)
      add(:legal_person_id, references(:legal_person, type: :binary_id))

      timestamps()
    end
  end
end
