defmodule ContractManagement do
  @moduledoc """
  ContractManagement keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ContractManagement.NaturalPersonContext

  defdelegate create_natural_person(params), to: NaturalPersonContext, as: :create
end
