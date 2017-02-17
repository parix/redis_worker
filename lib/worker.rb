require 'redis'
$stdout.sync = true

pubsub = Redis.new(:host => "redis")
queue = Redis.new(:host => "redis")

def process(queue)
  data = queue.lpop "channel"
  puts "data: #{data}"
  sleep(3)
end

pubsub.subscribe("channel") do |on|
  on.message do |channel, message|
    puts "processing #{message}"
    process(queue)
  end
end
