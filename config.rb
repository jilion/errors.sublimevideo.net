Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.async do |notice|
    Thread.new { Airbrake.sender.send_to_airbrake(notice) }
  end
end

Librato::Metrics.authenticate ENV['LIBRATO_METRICS_USER'], ENV['LIBRATO_METRICS_TOKEN']
$metrics_queue = Librato::Metrics::Queue.new(autosubmit_interval: 60)
