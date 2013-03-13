class AirbrakeDeliveryWorker
  include Sidekiq::Worker

  def perform(notice)
    Airbrake.sender.send_to_airbrake(notice)
  end
end
