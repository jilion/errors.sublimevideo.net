class ErrorReporter
  attr_reader :request, :params

  def initialize(env)
    @request, @params = Rack::Request.new(env), env['params']
  end

  def valid_error?
    params.has_key? 'message'
  end

  def report
    Airbrake.notify_or_ignore(_options)
    _increment_metrics
  end

  private

  def _options
    {
      error_class: "#{params['message']}/#{params['file']}:#{params['lineno']}",
      error_message: params['message'],
      parameters: params.merge(user_agent: request.user_agent),
      backtrace:  params['stack']
    }
  end

  def _increment_metrics
    $metrics_queue.add('player.errors' => { value: 1 })
  end
end
