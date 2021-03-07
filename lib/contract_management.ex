defmodule ContractManagement do
  @moduledoc """
  ContractManagement keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ContractManagement.{ContractContext, LegalPersonContext, NaturalPersonContext}

  defdelegate list_natural_people(), to: NaturalPersonContext, as: :list
  defdelegate create_natural_person(params), to: NaturalPersonContext, as: :create

  defdelegate list_legal_people(), to: LegalPersonContext, as: :list
  defdelegate create_legal_person(params), to: LegalPersonContext, as: :create

  defdelegate list_contracts(params), to: ContractContext, as: :list
  defdelegate create_contract(params), to: ContractContext, as: :create
end
