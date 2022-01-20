defmodule ExWeb3EcRecover.PersonalType do
  @moduledoc """
  This modules implements behaviour described in
  [EIP 191](https://eips.ethereum.org/EIPS/eip-191)

  Check `create_hash_from_personal_message/1` for details.
  """

  @doc """
  Creates a has of personal message hash.

  If `message` is a hex string it will parse the string and if it is a binary it
  it will be encoded directly.

  ## Examples

    iex> ExWeb3EcRecover.PersonalType.create_hash_from_personal_message(
    ...>   "hello world"
    ...> )
    <<217, 235, 161, 110, 208, 236, 174, 67, 43, 113, 254, 0, 140, 152, 204, 135,
    43, 180, 204, 33, 77, 50, 32, 163, 111, 54, 83, 38, 207, 128, 125, 104>>

    iex> ExWeb3EcRecover.PersonalType.create_hash_from_personal_message(
    ...>   "0x0cc175b9c0f1b6a831c399e26977266192eb5ffee6ae2fec3ad71c777531578f"
    ...> )
    <<69, 174, 138, 44, 5, 119, 42, 3, 176, 234, 146, 150, 249, 229, 84, 19,
    196,150, 121, 92, 232, 51, 41, 58, 31, 82, 183, 223, 101, 32, 68, 206>>

  """
  @spec create_hash_from_personal_message(String.t() | binary()) :: binary()
  def create_hash_from_personal_message(message)

  def create_hash_from_personal_message("0x" <> message) do
    message
    |> Base.decode16!(case: :mixed)
    |> create_hash_from_personal_message()
  end

  def create_hash_from_personal_message(orig_message) do
    ("\u0019Ethereum Signed Message:\n#{byte_size(orig_message)}" <> orig_message)
    |> ExKeccak.hash_256()
  end
end
