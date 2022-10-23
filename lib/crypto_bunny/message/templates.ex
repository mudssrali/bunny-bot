defmodule CryptoBunny.Message.Templates do
  @moduledoc """
  The Message Templates module
  """

  alias CryptoBunny.Message

  @doc """
  Returns text template
  """
  @spec text(event :: map(), text :: String.t()) :: map()
  def text(event, text) do
    %{
      "recipient" => %{
        "id" => Message.get_sender(event)["id"]
      },
      "message" => %{
        "text" => text
      }
    }
  end
end
