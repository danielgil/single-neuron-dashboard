require 'simplecov'
SimpleCov.start

require 'rack/test'
require 'fakeweb'
require 'minitest/autorun'
require 'minitest/pride'
require 'json_spec'

require_relative '../lib/snd'

ENV['RACK_ENV'] = 'test'

module Snd
  class Test < Minitest::Test
    include Rack::Test::Methods

    alias_method :silent, :capture_io

    def teardown

    end

    def last_json
      last_response.body
    end
  end
end