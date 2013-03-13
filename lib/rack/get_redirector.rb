module Rack
  class GETRedirector
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_METHOD'] == 'GET'
        [301, { 'Location' => 'http://sublimevideo.net' }, ["Redirect to http://sublimevideo.net"]]
      else
        @app.call(env)
      end
    end
  end
end
