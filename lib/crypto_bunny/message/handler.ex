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

  @max_coins 5
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

  # Handles message for coins search by name
  # In response to this message, we will send
  # postback message of max 5 coins to the recipient
  # to check price for the selected coin
  def handle_message(%{"text" => "CN_" <> query_text}, event) do
    Task.start(fn ->
      message = "Give us a moment, searching coins with '#{query_text}'"
      send_message(event, message)
    end)

    Logger.debug("searching coins with #{query_text}")

    case CoinGecko.search(query_text) do
      {:ok, data} ->
        coins = Map.get(data, "coins", [])
        max_coins = Enum.take(coins, @max_coins)

        # facebook messenger doesn't alow have more than 2 buttons
        # per message. To achieve let recipient to select one of coin,
        #
        # Following optoins:
        #
        # a. divide the buttons into multiple messages
        # b. use quick replies postbacks
        # c. send as text and let user respond with 1 to 5

        # To make it user friendly, let's split coins buttons into
        # multiple messages and send to recipient

        # Send title message
        send_message(event, "Select coin from below to see historical prices data from 1 to 5")

        # Send buttons in loop
        Enum.each(max_coins, fn coin ->
          title = """
          Market Capital Rank: #{coin["market_cap_rank"]}
          Symbol: #{coin["symbol"]}
          """

          coin_name = coin["name"]
          payload = "ID_" <> coin["id"]

          button = {:postback, coin_name, payload}

          event
          |> Templates.buttons(title, [button])
          |> Bot.send_message()
        end)

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
          "Please write Coins name to search in format: CN_[name] e.g. CN_bitcoin"
      end

    message = "Thank you, for your selection!\n" <> ssearch_guide

    send_message(event, message)
  end

  # Handles postback message for coin historical data
  def handle_postback(%{"payload" => "ID_" <> coin_id, "title" => title}, event) do
    Task.start(fn ->
      message = "Give us a moment, fetching historical price data for #{title} coin"
      send_message(event, message)
    end)

    case CoinGecko.get_market_chart(coin_id) do
      {:ok, historical_data} ->
        prices = Map.get(historical_data, "prices", [])
        prices_string = get_prices_string(prices)

        message =
          if prices == [] do
            "Historical price data not found for '#{title}', Try again."
          else
            "Historical price data for '#{title}' for past 14 days. \n\n" <>
              prices_string
          end

        send_message(event, message)

      {:error, _reason} ->
        send_message(event, "Something went wrong, Try again!")
    end
  end

  defp request_coins_search_method(event) do
    # the buttons strucuture looks as follow
    # {button_type, button_title, payload} = {:postback, "Green", "color_green"}

    buttons = [
      {:postback, "Coin ID", "coins_search_by_id"},
      {:postback, "Coins name", "coins_search_by_name"}
    ]

    template_title = "Would you like to search coins by?"
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
