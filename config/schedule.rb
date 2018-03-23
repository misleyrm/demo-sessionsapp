# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/logs/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every 3.hours do
#   runner "MyModel.some_process"
#   rake "my:rake:task"
#   command "/usr/bin/my_great_command"
# end
#
# every 1.day, :at => '4:30 am' do
#   runner "MyModel.task_to_run_at_four_thirty_in_the_morning"
# end
#
# every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
#   runner "SomeModel.ladeeda"
# end

set :output, "#{path}/log/cron.log"
# job_type :script, "'#{path}/script/:task' :output"

# every 15.minutes do
#   command "rm '#{path}/tmp/cache/foo.txt'"
#   script "generate_report"
# end

every 1.minute do
  # runner "User.cleardate"
  runner "User.cleardate"
  runner "HomeController.resetDate"
  # command "echo 'whenever gem test'"
end

# every :reboot do
#   rake "ts:start"
# end
