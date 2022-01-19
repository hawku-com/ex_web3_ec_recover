defmodule ExWeb3EcRecover.PersonalType do
  @moduledoc """
  This module defines logic for hashing personal signed messages.
  """
  def create_hash_from_personal_message(orig_message) do
    ("\u0019Ethereum Signed Message:\n#{byte_size(orig_message)}" <> orig_message)
    |> ExKeccak.hash_256()
  end
end
