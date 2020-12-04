Mosquito.configure do |settings|
  settings.redis_url = ENV["REDIS_URL"]
end

Mosquito::Runner.start
