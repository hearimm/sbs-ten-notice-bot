require 'singleton'
require 'telegram/bot'

module Sender
    class << self
        def send_message(text)
            token = ENV['TELEGRAM_BOT_TOKEN']
            chat_id = ENV['TELEGRAM_CHAT_ID']
            # parse_mode = "HTML"

            api =Telegram::Bot::Api.new(token)
            res_api = api.call('sendMessage',{:chat_id => chat_id, :text => text})
        end

        def send_err_message(text)
            token = ENV['TELEGRAM_BOT_TOKEN']
            p chat_id = ENV['TELEGRAM_ADMIN_CHAT_ID']
            # parse_mode = "HTML"

            api =Telegram::Bot::Api.new(token)
            res_api = api.call('sendMessage',{:chat_id => 52925068, :text => text}) 
        end

        # Sender::send_photo("http://img2.sbs.co.kr/sbs_img/2018/05/04/0504.png")
        def send_photo(url)
            token = ENV['TELEGRAM_BOT_TOKEN']
            chat_id = ENV['TELEGRAM_CHAT_ID']

            api =Telegram::Bot::Api.new(token)
            res_api = api.call('sendPhoto',{:chat_id => chat_id, :photo => url})
        end
    end
    
end
