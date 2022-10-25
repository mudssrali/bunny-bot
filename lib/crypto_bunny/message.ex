defmodule CryptoBunny.Message do
  @moduledoc """
  The Message module
  """

  alias CryptoBunny.Utils.TeslaClient

  @type event :: map()

  @doc """
  Returns sender profile
  """
  @spec get_sender_profile(event :: event()) :: {:ok, any()} | {:profile_not_found, any()}
  def get_sender_profile(event) do
    fb = Application.get_env(:crypto_bunny, :fb_bot)
    sender = get_sender(event)
    client = TeslaClient.client(:fb)

    case Tesla.get(client, sender["id"], query: [access_token: fb.page_access_token]) do
      {:ok, response} ->
        {:ok, response.body}

      {:error, reason} ->
        {:profile_not_found, reason}
    end
  end

  @doc """
  Returns message sender
  """
  @spec get_sender(event :: event()) :: map()
  def get_sender(event) do
    messaging = get_messaging(event)
    messaging["sender"]
  end

  @doc """
  Returns message receiver
  """
  @spec get_recipient(event :: event()) :: map()
  def get_recipient(event) do
    messaging = get_messaging(event)
    messaging["recipient"]
  end

  @doc """
  Returns message from event messaging
  """
  @spec get_message(event :: event()) :: map()
  def get_message(event) do
    messaging = get_messaging(event)
    messaging["message"]
  end

  @doc """
  Returns greeting message
  """
  @spec greeting() :: String.t()
  def greeting do
    """
    Hello :)
    Welcome to Crypto Bunny
    """
  end

  @doc """
  Returns event messsaging
  """
  @spec get_messaging(event :: event()) :: map()
  def get_messaging(event) do
    [entry | _other] = event["entry"]
    [messaging | _other] = entry["messaging"]

    messaging
  end
end
