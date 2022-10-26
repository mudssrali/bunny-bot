defmodule CryptoBunny.Message.Handler do
  @moduledoc """
  Provides message handlers
  """

  alias CryptoBunny.Bot
  alias CryptoBunny.Message
  alias CryptoBunny.Message.Templates
  alias CryptoBunny.CoinGecko
  alias CryptoBunny.Utils

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

    send_message(event, message)

    # We send button template to choose coin search method as
    #
    # You want to search coins by?
    # Coins ID
    # Coins name
    request_coins_search_method(event)
  end

  # Handles message for coin search by ID
  def handle_message(%{"text" => "ID_" <> coin_id}, event) do
    Task.start(fn ->
      message = "Give us a moment, fetching historical price data for #{coin_id} coin"
      send_message(event, message)
    end)

    case CoinGecko.get_market_chart(coin_id) do
      {:ok, historical_data} ->
        prices = Map.get(historical_data, "prices", [])
        prices_string = get_prices_string(prices)

        message =
          if prices == [] do
            "Historical price data not found for coin with id '#{coin_id}', Try again."
          else
            "Historical price data for coin with id '#{coin_id}' for past 14 days. \n\n" <>
              prices_string
          end

        send_message(event, message)

      {:error, _reason} ->
        send_message(event, "Something went wrong, Try again!")
    end
  end

  def handle_message(_message, event) do
    greetings = Message.greeting()

    message = """
    #{greetings}
    Sorry, got unknown message :(
    """

    send_message(event, message)
  end

  @doc """
  Handles postback event
  """
  @spec handle_postback(postback :: map(), event :: event()) :: :ok | :error
  def handle_postback(%{"payload" => "coins_search_by_" <> selected_method}, event) do
    ssearch_guide =
      case selected_method do
        "id" ->
          "Please write Coin ID in format: ID_[coin_id] " <>
            "e.g. ID_bitcoin to get market historical data"

        "name" ->
          "Please write Coins Name search in format: CN_[name] e.g. CN_bitcoin"
      end

    message = "Thank you, for your selection!\n" <> ssearch_guide

    send_message(event, message)
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

  defp get_prices_string(prices) do
    Enum.map(prices, fn [date, rate] ->
      date = Utils.Date.to_iso(date)
      rate = Utils.Currency.roundoff(rate)

      "#{date}: $#{rate}"
    end)
    |> Enum.join("\n")
  end

  defp send_message(event, message) do
    event
    |> Templates.text(message)
    |> Bot.send_message()
  end
end
