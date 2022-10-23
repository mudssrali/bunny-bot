defmodule CryptoBunny.Message.Handler do
  @moduledoc """
  Provides message handlers
  """

  alias CryptoBunny.Bot
  alias CryptoBunny.Message
  alias CryptoBunny.Message.Templates

  @doc false
  @spec handle_message(message :: any(), event :: map()) :: :ok | :error
  def handle_message(%{"text" => "hi"}, event) do
    {:ok, profile} = Message.get_sender_profile(event)

    {:ok, first_name} = Map.fetch(profile, "first_name")

    message = "Welcome to Crypto Bunny, #{first_name}"
    resp_body = Templates.text(event, message)

    IO.inspect(resp_body)

    Bot.send_message(resp_body)
  end

  def handle_message(_message, event) do
    greetings = Message.greeting()

    message = """
    #{greetings}
    Sorry, got unknown message :(
    """

    body = Templates.text(event, message)
    Bot.send_message(body)
  end
end
