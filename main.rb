# frozen_string_literal: true

require 'rubygems'
require './sender.rb'
require './crawler.rb'
require './repository.rb'
require './date_from_str.rb'

now_notice = Crawler.get_notice
latest = Repository::Latest.instance
history = Repository::History.instance
task = Repository::Task.instance

# p latest.find_one['notice']

if !latest.find_one.nil? && latest.find_one['notice'] == now_notice
  puts 'same'
else
  doc = { notice: now_notice, date: Time.now }
  p history.insert_one(doc)
  p latest.delete_all
  p latest.insert_one(doc)
  hash_list = DateFromStr.get_hash_list(now_notice)
  hash_list.each { |x| task.insert_one(x) }
  Sender.send_message(now_notice)
end


