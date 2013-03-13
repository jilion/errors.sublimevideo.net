require 'workers/airbrake_delivery_worker'

class ErrorReporter
  attr_reader :request, :params

  def initialize(env)
    @request, @params = Rack::Request.new(env), env['params']
  end

  def valid_error?
    params.has_key? 'message'
  end

  def report
    Airbrake.notify_or_ignore(params['message'], _options)
    _increment_metrics
  end

  private

  def _options
    {
      parameters:    params,
      backtrace:     params['stack'],
      parameters: {
        file:       params['file'],
        lineno:     params['lineno'],
        user_agent: request.user_agent
      }
    }
  end

  def _increment_metrics
    $metrics_queue.add('player.errors' => { value: 1 })
  end
end
