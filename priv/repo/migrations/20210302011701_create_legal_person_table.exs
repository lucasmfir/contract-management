defmodule ContractManagement.Repo.Migrations.CreateLegalPersonTable do
  use Ecto.Migration

  def change do
    create table(:legal_person) do
      add(:name, :string)
      add(:cnpj, :string)

      timestamps()
    end

    create unique_index(:legal_person, [:cnpj])
  end
end
