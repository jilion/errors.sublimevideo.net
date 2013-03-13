require 'new_relic/agent/instrumentation/rack'

module Rack
  class Newrelic
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end

    include NewRelic::Agent::Instrumentation::Rack
  end
end
