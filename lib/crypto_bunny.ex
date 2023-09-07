defmodule CryptoBunny do
  @moduledoc """
  The CryptoBunny Module
  """

  alias CryptoBunny.Messenger
  alias CryptoBunny.Messenger.{MessageHandler, Bot, MessageTemplates}


  @spec handle_event(event :: map()) :: :ok | :error
  def handle_event(event) do
    case Messenger.get_messaging(event) do
      %{"message" => message} ->
        MessageHandler.handle_message(message, event)

      %{"postback" => postback} ->
        MessageHandler.handle_postback(postback, event)

      _ ->
        error_body = MessageTemplates.text(event, "Something went wrong. Try again!")
        Bot.send_message(error_body)
    end
  end
end
