module Rack
  class Cors
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_METHOD'] == 'OPTIONS'
        [200, {
          'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'POST',
          'Access-Control-Allow-Headers' => 'Content-Type',
          'Access-Control-Max-Age' => '1728000'
        }, []]
      else
        status, headers, body = @app.call(env)
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Cache-Control'] = 'no-cache'
        [status, headers, body]
      end
    end
  end
end
