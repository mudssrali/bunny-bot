defmodule CryptoBunny.Message.Handler do
  @moduledoc """
  Provides message handlers
  """

  alias CryptoBunny.Bot
  alias CryptoBunny.Message
  alias CryptoBunny.Message.Templates

  require Logger

  @type event :: map()

  @doc """
  Handles message event
  """
  @spec handle_message(message :: map(), event :: event()) :: :ok | :error
  def handle_message(%{"text" => "hi"}, event) do
    {:ok, profile} = Message.get_sender_profile(event)

    {:ok, first_name} = Map.fetch(profile, "first_name")

    message = "Welcome to Crypto Bunny, #{first_name}"
    resp_body = Templates.text(event, message)

    IO.inspect(resp_body)

    Bot.send_message(resp_body)

    # We send button template to choose coin search method as
    #
    # You want to search coins by?
    # Coins ID
    # Coins name
    request_coins_search_method(event)
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

  @doc """
  Handles postback event
  """
  @spec handle_postback(postback :: map(), event :: event()) :: :ok | :error
  def handle_postback(%{"payload" => "coins_search_by_" <> selected_coins_search_method}, event) do
    Logger.info("selected coins search method: #{selected_coins_search_method}")

    event
    |> Templates.text("Thank you, for your selection, please wait!")
    |> Bot.send_message()
  end

  defp request_coins_search_method(event) do
    # the buttons strucuture looks as follow
    # {button_type, button_title, payload} = {:postback, "Green", "color_green"}

    buttons = [
      {:postback, "Coins ID", "coins_search_by_id"},
      {:postback, "Coins name", "coins_search_by_name"}
    ]

    template_title = "You would like to search coins by?"
    coin_search_method_template = Templates.buttons(event, template_title, buttons)

    # Send postback message
    Bot.send_message(coin_search_method_template)
  end
end
