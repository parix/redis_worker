require 'redis'
require 'json'
require 'securerandom'
$stdout.sync = true

class Job
  attr_accessor :id, :type, :status, :args

  def initialize(type:, args:)
    @id = SecureRandom.uuid
    @type = type
    @status = "queued"
    @args = args || []
  end

  def queue
    redis.lpush("#{type}_queue", id)
    redis.set(id, to_json)
    redis.publish("#{type}_events", "Queueing Job id: #{id}")
  end

  def to_hash
    { "id" => id, "type" => type, "status" => status, "args" => args }
  end

  def to_json
    JSON.dump(to_hash)
  end

  def redis
    @redis ||= Redis.new(:host => "redis")
  end

  def result
    JSON.parse(redis.get(id))["result"]
  end

  def self.create(type:, args:)
    job = self.new(:type => type, :args => args)
    job.queue
    job
  end
end

models = ["lebesgue_a_autodeny", "lebesgue_a_full_model", "lebesgue_b_autodeny", "lebesgue_b_full_model"]

jobs = models.map do |model|
  Job.create(:type => "r_model", :args => [model, {}])
end

while(jobs.map(&:result).compact.count < 4)
end

puts jobs.map(&:result).compact
