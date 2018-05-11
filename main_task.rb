require './sender.rb'
require './crawler.rb'
require './repository.rb'
require './date_from_str.rb'

task = Repository::Task.instance

result_task = task.find_one

if !result_task.nil? && result_task['time'] < Time.now + (60 * 10)
  Sender.send_message(result_task['desc'] + " [생녹방]")
  p task.delete_one(result_task['_id'])
else
  p "nothing"
end
