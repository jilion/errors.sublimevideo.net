Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.async do |notice|
    AirbrakeDeliveryWorker.perform_async(notice.to_xml)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

Librato::Metrics.authenticate ENV['LIBRATO_METRICS_USER'], ENV['LIBRATO_METRICS_TOKEN']
$metrics_queue = Librato::Metrics::Queue.new(autosubmit_interval: 60)
