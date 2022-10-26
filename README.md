# Bunny Bot

Facebook messenger chat bot to evaluate crypto currencies

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Runing with Docker

To run `bunny bot` inside docker on local machine, run the following commands

Build the docker image 

```shell
docker build -t bunny-bot:version-init .
```

Run the application inside docker container

```shell
docker run -d -e FB_PAGE_ACCESS_TOKEN=[put_fb_page_token_here] \
-e FB_WEBHOOK_VERIFY_TOKEN=[put_fb_webhook_verify_token_here] \
-p 4000:4000 \
--name bunny-bot bunny-bot:version-init
```

OR

Run the shell-script to run bunny bot inside docker container

> ./deploy-docker.sh

## Mix Test

Run following commands to run `tests` using `mix test` utility

> mix test

> mix test test/crypto_bunny

> mix test test/crypto_bunny_web/controllers

### Related Links
* [You don’t need chatbot creation tools — Let’s build a Messenger bot from scratch](https://www.freecodecamp.org/news/you-dont-needs-chatbot-creation-tools-let-s-build-a-messenger-bot-from-scratch-8fcbb40f073b/)
* [Postback Button Reference](https://developers.facebook.com/docs/messenger-platform/reference/buttons/postback)
* [CoinGecko - Explore the API](https://www.coingecko.com/en/api/documentation)