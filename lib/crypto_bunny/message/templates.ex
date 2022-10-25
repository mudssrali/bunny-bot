defmodule CryptoBunny.Message.Templates do
  @moduledoc """
  The Message Templates module
  """

  alias CryptoBunny.Message

  @type event :: map()

  @doc """
  Returns text template
  """
  @spec text(event :: event(), text :: String.t()) :: map()
  def text(event, text) do
    %{
      "recipient" => %{
        "id" => Message.get_sender(event)["id"]
      },
      "message" => %{
        "text" => text
      }
    }
  end

  @doc """
  Returns postback buttons template
  """
  @spec buttons(event :: event(), template_title :: String.t(), buttons :: list()) :: map()
  def buttons(event, template_title, buttons) do
    # Read more about postback buttons on
    # https://developers.facebook.com/docs/messenger-platform/reference/buttons/postback

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
    %{"id" => Message.get_sender(event)["id"]}
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
