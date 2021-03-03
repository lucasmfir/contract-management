defmodule ContractManagement.Repo.Migrations.CreateContractTable do
  use Ecto.Migration

  def change do
    create table(:contract) do
      add(:name, :string)
      add(:file, :binary)
      add(:description, :string)
      add(:date, :date)

      timestamps()
    end
  end
end
