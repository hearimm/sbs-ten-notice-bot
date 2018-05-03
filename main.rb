require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'json'
require 'dotenv/load'
require 'telegram/bot'

def bot_send_message(text)
    token = ENV['TELEGRAM_BOT_TOKEN']
    chat_id = ENV['TELEGRAM_CHAT_ID']
    
    url = "https://api.telegram.org/bot#{token}/sendMessage?chat_id=#{chat_id}&text=#{text}"
    uri = URI.parse(URI.escape(url))    
    api = Telegram::Bot::Api.new(token)
    res_api = api.call('sendMessage',{:chat_id => chat_id, :text => text})
    puts res_api
    
end
doc = Nokogiri::HTML(open("http://radio.sbs.co.kr/ten"), nil, 'EUC-KR')
# puts doc.encoding
# puts doc.meta_encoding
# puts doc
iframeDoc = Nokogiri::HTML(open(doc.css("frame")[1]["src"]), nil, 'EUC-KR')
# puts iframeDoc.encoding
# puts iframeDoc.meta_encoding
# iframeDoc = Nokogiri::HTML(open(doc.css("frame")[1]["src"]))
notice = iframeDoc.css("div[class=wizCnt]").css("b").text.to_s
# puts notice

client = Mongo::Client.new([ 'ds014648.mlab.com:14648' ], 
                            :database => ENV['MONGO_DB'], 
                            :user => ENV['MONGO_USER'], 
                            :password => ENV['MONGO_PW'])
latest_collection = client[:notice_latest]
latest_result = latest_collection.find().first()
if (latest_result != nil && latest_result["notice"] == notice)
    puts "same"
else
    collection = client[:notice_history]
    time = Time.now.to_s
    doc = { notice: notice, date: time }
    result_history = collection.insert_one(doc)
    latest_collection.delete_many()
    result_latest = latest_collection.insert_one(doc)
    puts result_latest
    bot_send_message(notice)
end
