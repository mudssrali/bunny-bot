defmodule CryptoBunny.Utils.Currency do
  @moduledoc """
  Provides helper functions to format currency
  """

  @doc """
  Returns rounded-off amount. Default set to 2 decimal places
  """
  @spec roundoff(amount :: number(), precision :: non_neg_integer()) :: number()
  def roundoff(amount, precision \\ 2) do
    Float.round(amount, precision)
  end
end
