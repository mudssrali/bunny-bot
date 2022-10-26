#!/bin/bash
# make sure this bash script has executable permission, if doesn't have, run following command
# > $ chmod +x *.sh

echo "starting building bunny bot with tag" $1

docker build -t bunny-bot:$1 .

echo "running the bunny-bot"

docker run -d -e FB_PAGE_ACCESS_TOKEN=[put_fb_page_token_here] \
-e FB_WEBHOOK_VERIFY_TOKEN=[put_fb_webhook_verify_token_here] \
-p 4000:4000 \
--name bunny-bot bunny-bot:$1

echo "completed!"