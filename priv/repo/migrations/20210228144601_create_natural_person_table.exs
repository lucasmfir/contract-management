defmodule ContractManagement.Repo.Migrations.CreateNaturalPersonTable do
  use Ecto.Migration

  def change do
    create table(:natural_person) do
      add(:name, :string)
      add(:cpf, :string)
      add(:birth_date, :date)

      timestamps()
    end

    create unique_index(:natural_person, [:cpf])
  end
end
