require 'error_reporter'

class Application
  def call(env)
    return [404, {}, { message: 'Not found' }] unless env['PATH_INFO'] == '/report'

    error_reporter = ErrorReporter.new(env)

    if error_reporter.valid_error?
      error_reporter.report
      [200, {}, { message: 'OK' }]
    else
      [400, {}, { message: 'Parameters must include a "message" key' }]
    end
  end
end
