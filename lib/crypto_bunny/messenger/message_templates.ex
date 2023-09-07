defmodule CryptoBunny.Messenger.MessageTemplates do
  @moduledoc """
  The Message Templates module -- Provides message templates
  """

  alias CryptoBunny.Messenger

  @type event :: map()

  @doc """
  Returns text template
  """
  @spec text(event :: event(), text :: String.t()) :: map()
  def text(event, text) do
    %{
      "recipient" => %{
        "id" => Messenger.get_sender(event)["id"]
      },
      "message" => %{
        "text" => text
      }
    }
  end

  @doc """
  Returns postback buttons template

  To read more about postback buttons, visit https://developers.facebook.com/docs/messenger-platform/reference/buttons/postback
  """
  @spec buttons(event :: event(), template_title :: String.t(), buttons :: list()) :: map()
  def buttons(event, template_title, buttons) do

    buttons = Enum.map(buttons, &prepare_button/1)

    payload = %{
      "template_type" => "button",
      "text" => template_title,
      "buttons" => buttons
    }

    recipient = recipient(event)

    message = %{
      "attachment" => attachment("template", payload)
    }

    template(recipient, message)
  end

  @doc """
  Prepares a button
  """
  @spec prepare_button(tuple()) :: map()
  def prepare_button({message_type, title, payload}) do
    %{
      "type" => "#{message_type}",
      "title" => title,
      "payload" => payload
    }
  end

  defp recipient(event) do
    %{"id" => Messenger.get_sender(event)["id"]}
  end

  defp attachment(type, payload) do
    %{
      "type" => type,
      "payload" => payload
    }
  end

  defp template(recipient, message) do
    %{
      "message" => message,
      "recipient" => recipient
    }
  end
end
