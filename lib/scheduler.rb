require 'redis'
$stdout.sync = true

redis = Redis.new(:host => "redis")

id = 0
while(true)
  puts "publishing: #{id}"
  redis.rpush "channel", { "hello_world" => id }
  redis.publish "channel", "job: #{id}"
  id += 1
  sleep(1)
end
