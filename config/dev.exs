import Config

# Facebook messenger's bot configuration

config :crypto_bunny,
  fb_bot: %{
    api_version: "v15.0",
    message_url: "me/messages",
    base_url: "https://graph.facebook.com",
    page_access_token: System.get_env("FB_PAGE_ACCESS_TOKEN"),
    webhook_verify_token: System.get_env("FB_WEBHOOK_VERIFY_TOKEN") || "fb-elixir-bot"
  }

# Coin Geck API configuration
config :crypto_bunny,
  coin_gecko: %{
    api_version: "v3",
    base_url: "https://api.coingecko.com/api"
  }

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :crypto_bunny, CryptoBunnyWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "pmlbNHV3hwb1GafA0LdTDBF3rFIOwWvIuU5hkSaijhiyN9AxtKCNftf3fMre8iNs",
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
