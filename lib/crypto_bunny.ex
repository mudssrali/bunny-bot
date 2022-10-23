defmodule CryptoBunny do
  @moduledoc """
  The CryptoBunny Module
  """

  alias CryptoBunny.Bot
  alias CryptoBunny.Message

  @spec handle_event(event :: map()) :: :ok | :error
  def handle_event(event) do
    case Message.get_messaging(event) do
      %{"message" => message} ->
        Message.Handler.handle_message(message, event)
      _ ->
        error_body = Message.Templates.text(event, "Something went wrong. Try again!")
        Bot.send_message(error_body)
    end
  end
end
