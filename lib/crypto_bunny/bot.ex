defmodule CryptoBunny.Bot do
  @moduledoc """
  The Bot module
  """

  require Logger

  @doc """
  Verifies webhook token
  """
  @spec verify_webhook(params :: nil | maybe_improper_list() | map()) :: boolean()
  def verify_webhook(params) do
    chat_bot = Application.get_env(:crypto_bunny, :fb_chat_bot)

    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == chat_bot.webhook_verify_token
  end

  @doc """
  Sends message to bot
  """
  @spec send_message(body :: map()) :: :ok | :error
  def send_message(body) do
    url = get_endpoint()

    body = Jason.encode!(body)

    case Tesla.post(url, body, headers: [{"content-type", "application/json"}]) do
      {:ok, _resp} ->
        Logger.info("Message sent to bot")

      {:error, reason} ->
        Logger.error("Unable to send message to bot \n #{inspect(reason)}")
        :error
    end
  end

  @doc """
  Returns bot endpoint
  """
  @spec get_endpoint() :: String.t()
  def get_endpoint() do
    bot_config = Application.get_env(:crypto_bunny, :fb_chat_bot)

    page_token = bot_config.page_access_token
    token_path = "?access_token=#{page_token}"

    [
      bot_config.base_url,
      bot_config.api_version,
      bot_config.message_url,
      token_path
    ]
    |> Enum.join("/")
  end
end
