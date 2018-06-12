# Sidekiq.configure_server do |config|
#   config.redis = { url: 'redis://h:p79df61a8ef69dadf4343b2505cdbae27004a8ee8b2a24adcb8f86783a75b4b04@ec2-35-170-218-206.compute-1.amazonaws.com:6899',size: 27 }
# end
#
# # Sidekiq.configure_client do |config|
# #   # config.redis = { url: 'redis://h:p79df61a8ef69dadf4343b2505cdbae27004a8ee8b2a24adcb8f86783a75b4b04@ec2-52-2-220-105.compute-1.amazonaws.com:9789',:size => 5 }
# # end
# Sidekiq.configure_client do |config|
#   config.redis = { size: 13 }
# end


if Rails.env.production?

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'], size: 2 }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], size: 27 }

    Rails.application.config.after_initialize do
      Rails.logger.info("DB Connection Pool size for Sidekiq Server before disconnect is: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
      ActiveRecord::Base.connection_pool.disconnect!

      ActiveSupport.on_load(:active_record) do
        config = Rails.application.config.database_configuration[Rails.env]
        config['reaping_frequency'] = ENV['DATABASE_REAP_FREQ'] || 10 # seconds
        # config['pool'] = ENV['WORKER_DB_POOL_SIZE'] || Sidekiq.options[:concurrency]
        config['pool'] = 16
        ActiveRecord::Base.establish_connection(config)

        Rails.logger.info("DB Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
      end
    end
  end

end
