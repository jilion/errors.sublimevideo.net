#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require "bundler"
Bundler.require

require './config'
require 'rack/status'
require "rack/timeout"
require 'rack/newrelic'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json'
require 'application'

use Airbrake::Rack
use Rack::Timeout
use Rack::Status
use Rack::Newrelic
use Rack::GETRedirector
use Rack::Cors
use Rack::JSON

run Application.new
