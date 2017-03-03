require 'redis'
require 'json'
$stdout.sync = true

class Worker
  @@type = "default"

  def redis
    @redis ||= Redis.new(:host => "redis")
  end

  def start
    while(true) do
      queue, id = redis.brpop("#{@@type}_queue", :timeout => 0)
      job = JSON.parse(redis.get(id))
      puts "Working on Job id: #{id} with args: #{job["args"]}"
      job["result"] = process(*job["args"])
      puts "Finished Job id: #{id} result: #{job["result"]}"
      redis.set(id, JSON.dump(job))
    end
  end

  def self.start
    worker = self.new
    worker.start
  end
end

class RModel < Worker
  @@type = "r_model"

  def process(model, data)
    puts "Scoring #{model} with #{data}"
    case model
    when "lebesgue_a_autodeny"
      sleep(2)
      91.12
    when "lebesgue_a_full_model"
      sleep(17)
      68.49
    when "lebesgue_b_autodeny"
      sleep(2)
      95.92
    when "lebesgue_b_full_model"
      sleep(17)
      84.58
    else
      sleep(5)
      0.00
    end
  end
end

RModel.start
