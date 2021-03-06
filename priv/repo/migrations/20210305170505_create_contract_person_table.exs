defmodule ContractManagement.Repo.Migrations.CreateContractPersonTable do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE person_type AS ENUM('natural_person', 'legal_person');")

    create table(:contract_person) do
      add(:contract_id, references(:contract, type: :binary_id))
      add(:person_id, :binary_id)
      add(:person_type, :person_type)

      timestamps()
    end

    create unique_index(:contract_person, [:contract_id, :person_id])
  end

  def down do
    drop table(:contract_person)

    execute("DROP TYPE person_type;")
  end
end
