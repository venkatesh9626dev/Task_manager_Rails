


Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }  # remove `namespace`
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }  # remove `namespace`
end

