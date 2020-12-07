# bitcoin blocks diff alert

HOST="127.0.0.1"    # bitcoindのHostを設定<br>
PORT=8332             # Mainnet以外の場合は変更<br>
RPCUSER="user"          # bitcoindのRPCUSERを設定<br>
RPCPASSWORD="password"      # bitcoindのRPCPASSWORDを設定<br>

SLACK_URL = "https://hooks.slack.com/services/******/***********/**********"     # SlackのWebhookを設定

上記のパラメータを設定して、

```
ruby watch-bitcoin-block.rb
```
