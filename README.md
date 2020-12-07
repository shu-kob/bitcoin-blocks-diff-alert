# bitcoin blocks diff alert

HOST="127.0.0.1"    # bitcoindのHostを設定
PORT=8332             # Mainnet以外の場合は変更
RPCUSER="user"          # bitcoindのRPCUSERを設定
RPCPASSWORD="password"      # bitcoindのRPCPASSWORDを設定

SLACK_URL = "https://hooks.slack.com/services/******/****************/****************"     # SlackのWebhookを設定

上記のパラメータを設定して、

```
ruby watch-bitcoin-block.rb
```
