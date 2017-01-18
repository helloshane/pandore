
# frozen_string_literal: true
$redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD'], db: ENV['REDIS_DB'])
