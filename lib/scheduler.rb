require 'redis'
require 'json'
require 'securerandom'
$stdout.sync = true

class Job
  attr_accessor :id, :name, :args

  def initialize(name:, args:)
    @id = SecureRandom.uuid
    @name = name
    @args = args || []
  end

  def queue
    redis.lpush("#{@name}_jobs", { "id" => @id, "args" => @args }.to_json)
    redis.publish("#{@name}_events", "Queueing Job id: #{@id}")
  end

  def redis
    @redis ||= Redis.new(:host => "redis")
  end

  def result
    hredis.hget("#{@name}_results", @id)
  end

  def self.create(name:, args:)
    job = self.new(:name => name, :args => args)
    job.queue
    job
  end
end

models = ["lebesgue_a_autodeny", "lebesgue_a_full_model", "lebesgue_b_autodeny", "lebesgue_b_full_model"]

jobs = models.map do |model|
  Job.create(:name => "r_model", :args => [model, {}])
end

while(jobs.map(&:result).compact.count < 4)
end

puts jobs.map(&:result).compact
