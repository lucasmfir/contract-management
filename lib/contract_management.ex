defmodule ContractManagement do
  @moduledoc """
  ContractManagement keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ContractManagement.{ContractContext, LegalPersonContext, NaturalPersonContext}

  defdelegate get_natural_people(), to: NaturalPersonContext, as: :get_all
  defdelegate create_natural_person(params), to: NaturalPersonContext, as: :create

  defdelegate get_legal_people(), to: LegalPersonContext, as: :get_all
  defdelegate create_legal_person(params), to: LegalPersonContext, as: :create

  defdelegate get_contracts(params), to: ContractContext, as: :get_contracts
  defdelegate create_contract(params), to: ContractContext, as: :create
end
