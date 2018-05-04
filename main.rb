require 'rubygems'
require './sender.rb'
require './crawler.rb'
require './repository.rb'

now_notice = Crawler::get_notice
latest = Repository::Latest.instance
history = Repository::History.instance

if (latest.get_one != nil && latest.get_one["notice"] == now_notice)
    puts "same"
else
    time = Time.now.to_s
    doc = { notice: now_notice, date: time }
    p history.insert_one(doc)
    p latest.delete_all
    p latest.insert_one(doc)
    Sender::send_message(now_notice)
end