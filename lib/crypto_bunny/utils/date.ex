defmodule CryptoBunny.Utils.Date do
  @moduledoc """
  Provides helper functions to work with date or timestamp
  """

  @doc """
  Returns date in ISO format from unix
  """
  @spec to_iso(unix_timestamp :: non_neg_integer()) :: String.t()
  def to_iso(unix_timestamp) do
    {:ok, date} = DateTime.from_unix(unix_timestamp, :millisecond)

    Date.to_string(date)
  end
end
