require 'net/http'
require 'json'

url = URI.parse("https://blockchain.info/latestblock")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
req = Net::HTTP::Get.new(url.path)
res = https.request(req)
explorer_latest_block = JSON.parse(res.body)
puts explorer_latest_block["height"]
explorer = explorer_latest_block["height"].to_s
puts explorer

method = 'getblockchaininfo'
param = []
HOST="127.0.0.1"    # 環境に合わせて変更
PORT=8332
RPCUSER="user"          # 環境に合わせて変更
RPCPASSWORD="password"      # 環境に合わせて変更
http = Net::HTTP.new(HOST, PORT)
request = Net::HTTP::Post.new('/')
request.basic_auth(RPCUSER,RPCPASSWORD)
request.content_type = 'application/json'
request.body = {method: method, params: param, id: 'jsonrpc'}.to_json
bitcoind_latest_block = JSON.parse(http.request(request).body)["result"]
puts bitcoind_latest_block["blocks"]
bitcoind = bitcoind_latest_block["blocks"].to_s
puts bitcoind

SLACK_URL = "https://hooks.slack.com/services/******/****************/****************"

def alert
  message = {
    text: "bitcoindとexplorerのブロック差が3以上離れています"
  }

  notify_to_slack(message)
end

def notify_to_slack(message)
  uri = URI.parse(SLACK_URL)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.start do
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(payload: message.to_json)
    http.request(request)
  end
end

if (explorer_latest_block["height"] - bitcoind_latest_block["blocks"]).abs >= 3
  alert
end