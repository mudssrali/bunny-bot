defmodule CryptoBunnyWeb.API.FacebookController do
  use CryptoBunnyWeb, :controller

  alias CryptoBunny
  alias CryptoBunny.Messenger.Bot

  @doc """
  We need to check params sent by message to bot get request.

  Params contains multiple keys, we need to deal with "hub.verify_token",
  "hub.mode" and "hub.challenge".

  We just need to verify "hub.verify_token" is same as in application config.
  If verified, we send "hub.challenge" key as a response from the params
  """
  @spec verify_webhook_token(conn :: Plug.Conn.t(), params :: nil | maybe_improper_list() | map()) ::
          Plug.Conn.t()
  def verify_webhook_token(conn, params) do
    verified? = Bot.verify_webhook(params)

    if verified? do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, params["hub.challenge"])
      |> send_resp()
    else
      resp_body =
        Jason.encode!(%{
          status: "error",
          message: "unauthorized"
        })

      conn
      |> put_resp_content_type("application/json")
      |> resp(403, resp_body)
    end
  end

  @doc """
  Receive webhook events sent by the Facebook
  """
  @spec handle_event(conn :: Plug.Conn.t(), params :: nil | maybe_improper_list() | map()) ::
          Plug.Conn.t()
  def handle_event(conn, params) do
    CryptoBunny.handle_event(params)

    body = %{
      status: "ok"
    }

    conn
    |> put_resp_content_type("application/json")
    |> resp(200, Jason.encode!(body))
  end
end
