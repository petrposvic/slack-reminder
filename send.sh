#!/bin/bash
set -eo pipefail

# https://api.slack.com/apps?new_app=1
# App Name = Slack Reminder
# Development Slack Workspace = Choose one
# Click Incoming Webhooks
# Activate Incoming Webhooks
# Add New Webhook to Workspace
# Post to: #general
#
# crontab -e # You can visit https://crontab.guru
# 0 16 * * SUN /root/slack-reminder/send.sh AAAAA1234/BBBB12345/CCCCCccccc12345678910 > /dev/null 2>&1

if [ $# -ne 1 ]; then
  echo "Usage: $0 token"
  exit 1
fi

for BIN in /usr/bin/curl /usr/bin/shuf; do
  if [[ ! -f $BIN || ! -x $BIN ]]; then
    echo "$BIN is not file or executable"
    exit 2
  fi
done

cd "$(dirname "$0")"
if [[ ! -r messages.txt ]]; then
  echo "File 'messages.txt' is not readable"
  exit 3
fi

# Delay 0 - 59 minutes
DELAY=$((RANDOM % 60))
echo "Sending Slack notification in $DELAY minutes"
sleep $((DELAY * 60))

curl -s -X POST -H 'Content-type: application/json' --data '{"text":"'"`shuf -n 1 messages.txt`"'!"}' https://hooks.slack.com/services/$1 > /dev/null
