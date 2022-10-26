defmodule CryptoBunnyWeb.FacebookControllerTest do
  use CryptoBunnyWeb.ConnCase

  describe "Verify FB Webhook Token" do
    test "GET /api/facebook-webhook with valid verify token" do
      conn = build_conn()

      params = %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => "pokemon",
        "hub.challenge" => 147_852_369
      }

      conn = get(conn, Routes.facebook_path(conn, :verify_webhook_token, params))
      assert json_response(conn, 200)

      # verify challenge
      assert json_response(conn, 200) == params["hub.challenge"]
    end

    test "GET /api/facebook-webhook with invalid verify token" do
      conn = build_conn()

      params = %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => "random",
        "hub.challenge" => 147_852_369
      }

      conn = get(conn, Routes.facebook_path(conn, :verify_webhook_token, params))
      assert json_response(conn, 403)

      # assert serialization
      assert json_response(conn, 403) == %{
               "status" => "error",
               "message" => "unauthorized"
             }
    end
  end
end
