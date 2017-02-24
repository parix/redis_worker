require 'redis'
require 'json'
$stdout.sync = true

class Worker
  def pubsub
    @pubsub ||= Redis.new(:host => "redis")
  end

  def queue
    @queue ||= Redis.new(:host => "redis")
  end

  def dequeue
    if job = queue.rpop("r_model")
      job = JSON.parse(job)
      puts "Working on Job id: #{job["id"]} with args: #{job["args"]}"
    end
  end

  def self.start
    worker = self.new
    worker.pubsub.subscribe("r_model") do |on|
      on.message do |channel, message|
        worker.dequeue
      end
    end
  end
end

class RModel < Worker
  @@name = "r_model"

  def process(model, data)
    puts "Scoring #{model} with #{data}"
  end
end

RModel.start
