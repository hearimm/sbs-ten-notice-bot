require './sender.rb'
require './crawler.rb'
require './repository.rb'
require './date_from_str.rb'
begin
  view_task = Repository::ViewTask.instance

  wday = Date.today.wday
  result = view_task.find_one(wday)
  # result = {:weekday=>5, :weekday_kor=>"금요일", desc: "베스트 10 이석우 기자", view_yn: "Y"}
  p msg = result[:desc] + (result[:view_yn] == 'Y' ? ' [보이는 라디오]' : ' [녹방]')
  Sender.send_message(msg)

rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
  Sender.send_err_message("#{e.message}\n#{e.backtrace.inspect}")

end
