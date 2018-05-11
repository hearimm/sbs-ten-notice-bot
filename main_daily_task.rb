require './sender.rb'
require './crawler.rb'
require './repository.rb'
require './date_from_str.rb'
view_task = Repository::ViewTask.instance

wday = Date.today.wday
result = view_task.find_one(wday)
# result = {:weekday=>5, :weekday_kor=>"금요일", desc: "베스트 10 이석우 기자", view_yn: "Y"}
p msg = result[:desc] + (result[:view_yn] == 'Y' ? ' [보이는 라디오]' : '')

Sender.send_message(msg)