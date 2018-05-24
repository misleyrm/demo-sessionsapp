# uri = URI.parse(ENV["REDISTOGO_URL"])
# REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#

$redis = Redis.new(url: ENV["REDIS_URL"])
