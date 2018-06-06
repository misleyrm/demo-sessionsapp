Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://h:p79df61a8ef69dadf4343b2505cdbae27004a8ee8b2a24adcb8f86783a75b4b04@ec2-52-2-220-105.compute-1.amazonaws.com:9789' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://h:p79df61a8ef69dadf4343b2505cdbae27004a8ee8b2a24adcb8f86783a75b4b04@ec2-52-2-220-105.compute-1.amazonaws.com:9789' }
end
