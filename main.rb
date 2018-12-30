# frozen_string_literal: true

require 'rubygems'
require './sender.rb'
require './crawler.rb'
require './repository.rb'
require './date_from_str.rb'

begin

  latest = Repository::Latest.instance
  history = Repository::History.instance
  task = Repository::Task.instance
  view_latest = Repository::ViewLatest.instance
  view_task = Repository::ViewTask.instance
  now_notice = Crawler.get_notice_plane
  view_now_html = Crawler.get_view_radio

  if !view_latest.find_one.nil? && view_latest.find_one['html'] == view_now_html
    puts 'view_radio_same'
  else
    doc = { html: view_now_html, date: Time.now }
    view_latest.delete_all
    view_latest.insert_one(doc)

    hash_list = Crawler.get_view_radio_hash(view_now_html)
    view_task.delete_all
    view_task.insert_many(hash_list)
  end

  if !latest.find_one.nil? && latest.find_one['notice'] == now_notice
    puts 'notice_same'
  elsif now_notice.empty?
    puts 'notice_is_empty'
  else
    doc = { notice: now_notice, date: Time.now }
    p history.insert_one(doc)
    p latest.delete_all
    p latest.insert_one(doc)
    hash_list = DateFromStr.get_hash_list_from_plane(now_notice)
    task.delete_all
    task.insert_many(hash_list)
    Sender.send_err_message(hash_list.map{|x| x[:time].strftime "%m/%d(%a)%H:%M" + " " + x[:desc]}.join("\n"))
    Sender.send_message(now_notice.gsub(/(((?:[1-2][0-9]|[0-9])(?:\/)(?:[0-3][0-9]|[0-9]))|((?:0[0-9]|1[0-9]|2[0-3])+:[0-5][0-9]))/,"\n"+'\1'))
  end

rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
  Sender.send_err_message("#{e.message}\n#{e.backtrace.inspect}")
end
