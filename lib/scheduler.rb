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
    redis.lpush(@name, { "id" => @id, "args" => @args }.to_json)
    redis.publish(@name, "Queueing Job id: #{@id}")
  end

  def redis
    @redis ||= Redis.new(:host => "redis")
  end

  def self.create(name:, args:)
    job = self.new(:name => name, :args => args)
    job.queue
  end
end

models = ["lebesgue_a_autodeny", "lebesgue_a_full_model", "lebesgue_b_autodeny", "lebesgue_b_full_model"]
while(true)
  Job.create(:name => "r_model", :args => [models.sample, {}])
  sleep(1 + rand(2))
end
