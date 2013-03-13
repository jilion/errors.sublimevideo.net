require 'spec_helper'
require 'rack/test'
APP = Rack::Builder.parse_file('config.ru').first

describe Application do
  include Rack::Test::Methods

  def app
    APP
  end

  context 'on /status path' do
    it 'responses OK on GET /status' do
      get '/status'
      last_response.body.should eq 'OK'
    end

    it 'responses OK on POST /status' do
      post '/status'
      last_response.body.should eq 'OK'
    end
  end

  context 'any GET requests other than status' do
    it 'redirects to http://sublimevideo.net' do
      get '/report'
      last_response.status.should eq 301
      last_response.body.should eq 'Redirect to http://sublimevideo.net'
    end
  end

  context 'POST on unknown path' do
    it 'responds 404' do
      post '/foo'
      last_response.status.should eq 404
      MultiJson.load(last_response.body).should eq({ 'message' => 'Not found' })
    end
  end

  context 'on /report path' do
    it 'responses with CORS headers on OPTIONS' do
      options '/report'
      headers = last_response.header
      headers['Access-Control-Allow-Origin'].should eq '*'
      headers['Access-Control-Allow-Methods'].should eq 'POST'
      headers['Access-Control-Allow-Headers'].should eq 'Content-Type'
      headers['Access-Control-Max-Age'].should eq '1728000'
    end

    it 'responses with CORS headers on POST' do
      post '/report'
      last_response.header['Access-Control-Allow-Origin'].should eq '*'
    end

    it 'always responds in JSON' do
      post '/report', nil, 'Content-Type' => 'text/plain'
      last_response.headers['Content-Type'].should eq 'application/json'
    end

    context 'without message, file and lineno' do
      let(:error_data) { { stack: [] } }
      before { post '/report', MultiJson.dump(error_data) }

      it 'responds with 400' do
        last_response.status.should eq 400
        MultiJson.load(last_response.body).should eq({ 'message' => 'Parameters must include a "message" key, or both "file" and "lineno" keys' })
      end
    end

    context 'without message and file' do
      let(:error_data) { { lineno: 42, stack: [] } }
      before { post '/report', MultiJson.dump(error_data) }

      it 'responds with 400' do
        last_response.status.should eq 400
        MultiJson.load(last_response.body).should eq({ 'message' => 'Parameters must include a "message" key, or both "file" and "lineno" keys' })
      end
    end

    context 'with message only' do
      let(:error_data) { { message: 'Undefined method "play"!' } }
      before { post '/report', MultiJson.dump(error_data) }

      it 'responds with 200' do
        last_response.status.should eq 200
        MultiJson.load(last_response.body).should eq({ 'message' => 'OK' })
      end
    end

    context 'with file and lineno only' do
      let(:error_data) { { file: 'player.js', lineno: 42 } }
      before { post '/report', MultiJson.dump(error_data) }

      it 'responds with 200' do
        last_response.status.should eq 200
        MultiJson.load(last_response.body).should eq({ 'message' => 'OK' })
      end
    end

    context 'with error data' do
      let(:error_data) do
        {
          file: 'player.js',
          lineno: 42,
          message: 'Undefined method "play"!',
          stack: []
        }
      end
      before { post '/report', MultiJson.dump(error_data) }

      it 'responds with 200' do
        last_response.status.should eq 200
        MultiJson.load(last_response.body).should eq({ 'message' => 'OK' })
      end
    end
  end
end
