defmodule CryptoBunny.Bot do
  @moduledoc """
  The Bot module
  """
  alias CryptoBunny.Utils.TeslaClient

  require Logger

  @doc """
  Verifies webhook token
  """
  @spec verify_webhook(params :: nil | maybe_improper_list() | map()) :: boolean()
  def verify_webhook(params) do
    chat_bot = Application.get_env(:crypto_bunny, :fb_bot)

    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == chat_bot.webhook_verify_token
  end

  @doc """
  Sends message to bot
  """
  @spec send_message(body :: map()) :: :ok | :error
  def send_message(body) do
    fb = Application.get_env(:crypto_bunny, :fb_bot)
    client = TeslaClient.client(:fb)

    case Tesla.post(client, fb.message_url, body,
           query: [access_token: fb.page_access_token],
           headers: [{"content-type", "application/json"}]
         ) do
      {:ok, _resp} ->
        Logger.info("Message sent to bot")

      {:error, reason} ->
        Logger.error("Unable to send message to bot \n #{inspect(reason)}")
        :error
    end
  end
end
