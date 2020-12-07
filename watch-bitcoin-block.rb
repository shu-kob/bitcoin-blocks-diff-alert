require 'net/http'
require 'json'

url = URI.parse("https://blockchain.info/latestblock")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
req = Net::HTTP::Get.new(url.path)
res = https.request(req)
begin
  explorer_latest_block = JSON.parse(res.body)
  explorer_blockheight = explorer_latest_block["height"]
  puts explorer_blockheight
rescue => e
  puts e
  explorer_blockheight = -1
end

method = 'getblockchaininfo'
param = []
HOST="127.0.0.1"    # bitcoindのHostを設定
PORT=8332
RPCUSER="user"          # bitcoindのRPCUSERを設定
RPCPASSWORD="password"      # bitcoindのRPCPASSWORDを設定
http = Net::HTTP.new(HOST, PORT)
request = Net::HTTP::Post.new('/')
request.basic_auth(RPCUSER,RPCPASSWORD)
request.content_type = 'application/json'
request.body = {method: method, params: param, id: 'jsonrpc'}.to_json
begin
  bitcoind_latest_block = JSON.parse(http.request(request).body)["result"]
  bitcoind_blockheight = bitcoind_latest_block["blocks"]
  puts bitcoind_blockheight
rescue => e
  puts e
  bitcoind_blockheight = -1
end

SLACK_URL = "https://hooks.slack.com/services/******/****************/****************"     # SlackのWebhookを設定

def alert(bitcoind_blockheight, explorer_blockheight)
  if bitcoind_blockheight == -1
    message = {
      text: "bitcoindから情報を取得できません",
    }
  elsif explorer_blockheight == -1
    message = {
      text: "explorerから情報を取得できません",
    }
  else
    message = {
      text: "bitcoindとexplorerのブロック差が3以上離れています bitcoind: #{bitcoind_blockheight} explorer: #{explorer_blockheight}",
    }
  end
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

if bitcoind_blockheight == -1 or explorer_blockheight == -1 or (explorer_blockheight - bitcoind_blockheight).abs >= 3
  alert(bitcoind_blockheight, explorer_blockheight)
end