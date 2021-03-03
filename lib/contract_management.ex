defmodule ContractManagement do
  @moduledoc """
  ContractManagement keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ContractManagement.{LegalPersonContext, NaturalPersonContext}

  defdelegate create_natural_person(params), to: NaturalPersonContext, as: :create

  defdelegate create_legal_person(params), to: LegalPersonContext, as: :create
end
