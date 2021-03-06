defmodule ContractManagement.Contract do
  use Ecto.Schema
  import Ecto.Changeset

  alias ContractManagement.ContractPerson

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params ~w(name file file_data description date)a
  @foreign_key_type :binary_id

  schema "contract" do
    field :name, :string
    field :file, :binary
    field :file_data, :map, virtual: true
    field :description, :string
    field :date, :date
    has_many :contract_person, ContractPerson

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_file_format()
    |> put_file_content()
    |> put_file_name()
    |> validate_required(@required_params)
  end

  defp validate_file_format(%{changes: %{file_data: _}} = changeset) do
    validate_change(changeset, :file_data, fn :file_data, file_data ->
      case file_data.content_type do
        "application/pdf" -> []
        _ -> [{:file_data, "file must be a pdf type"}]
      end
    end)
  end

  defp validate_file_format(changeset), do: changeset

  defp put_file_content(%{changes: %{file_data: _} = changes} = changeset) do
    file_data_path = changes.file_data.path

    {:ok, file_content} = File.read(file_data_path)

    change(changeset, %{file: file_content})
  end

  defp put_file_content(changeset), do: changeset

  defp put_file_name(%{changes: changes} = changeset) do
    case Map.has_key?(changes, :name) do
      false ->
        %{file_data: file_data} = changes
        change(changeset, %{name: file_data.filename})

      true ->
        changeset
    end
  end
end
