require 'redis'
$stdout.sync = true

pubsub = Redis.new(:host => "redis")
queue = Redis.new(:host => "redis")

def process(queue)
  data = queue.rpop "channel"
  if data
    puts "data: #{data}"
  else
    puts "queue is empty"
  end
  sleep(1 + rand(5))
end

pubsub.subscribe("channel") do |on|
  on.message do |channel, message|
    puts "processing #{message}"
    process(queue)
  end
end
