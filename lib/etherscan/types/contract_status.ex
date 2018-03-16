defmodule Etherscan.ContractStatus do
  @moduledoc """
  Etherscan module for the ContractStatus struct.
  """

  @attributes [
    :isError,
    :errDescription,
  ]

  defstruct @attributes

  @type t :: %__MODULE__{
    isError: String.t(),
    errDescription: String.t(),
  }
end
