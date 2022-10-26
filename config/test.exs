import Config

# Facebook messenger's bot configuration
config :crypto_bunny,
  fb_bot: %{
    api_version: "v15.0",
    message_url: "me/messages",
    base_url: "https://graph.facebook.com",
    page_access_token: "not-specified-page",
    webhook_verify_token: "pokemon"
  }

# Coin Geck API configuration
config :crypto_bunny,
  coin_gecko: %{
    api_version: "v3",
    base_url: "https://api.coingecko.com/api"
  }

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crypto_bunny, CryptoBunnyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6noR/O0UFUgUaNl/0V/CojQq1lIiHEPTajSnkdVDVEN/jGhLgOCYzvF+CHflCK9J",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
