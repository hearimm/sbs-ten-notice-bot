# frozen_string_literal: true

require 'rubygems'
require './sender.rb'
require './crawler.rb'
require './repository.rb'
require './date_from_str.rb'

latest = Repository::Latest.instance
history = Repository::History.instance
task = Repository::Task.instance
view_latest = Repository::ViewLatest.instance
view_task = Repository::ViewTask.instance
now_notice = Crawler.get_notice
view_now_html = Crawler.get_view_radio
# p latest.find_one['notice']

if !view_latest.find_one.nil? && view_latest.find_one['html'] == view_now_html
  puts 'view_radio_same'
else
  doc = { html: view_now_html, date: Time.now }
  view_latest.delete_all
  view_latest.insert_one(doc)

  hash_list = Crawler.get_view_radio_hash(view_now_html)
  view_task.insert_many(hash_list)
end

if !latest.find_one.nil? && latest.find_one['notice'] == now_notice
  puts 'notice_same'
else
  doc = { notice: now_notice, date: Time.now }
  p history.insert_one(doc)
  p latest.delete_all
  p latest.insert_one(doc)
  hash_list = DateFromStr.get_hash_list(now_notice)
  task.insert_many(hash_list)
  Sender.send_message(now_notice)
end