# uri = URI.parse(ENV['REDISTOGO_URL'])
REDIS = Redis.new(:url => ENV['REDISTOGO_URL'])

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISTOGO_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISTOGO_URL'] }
end
