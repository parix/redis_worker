# Redis Structure
```ruby
{
  "some-type_queue" => ["some-example-uuid"], # list
  "some-type_status-queued" => [...], # set
  "some-type_status-processing" => [...], # set
  "some-type_status-finished" => [...], # set
  "some-type_status-failed" => [...], # set
  "some-example-uuid:type" => "some-type", # string
  "some-example-uuid:status" => "queued", # string
  "some-example-uuid:args" => ["arg1", "arg2"] # list
  "some-example-uuid:result" => "1" # string, 
  "some-exmaple-uuid" => "{\"type\":\"some-type\",\"status\":\"queued\",\"args\":[\"arg1\",\"arg2\"],\"result\":\"1\"}" # string
}
```

# Job Instance
```ruby
#<Job id: "some-example-uuid", type: "job-name", args: ["arg1", "arg2", ... , "argn"], status: "#{"queued" | "processing" | "finished" | "failed"}", result: "result">
```

# Job API
```ruby
Job.where(:id => [...], :type => [...], status: [...]) 
```
