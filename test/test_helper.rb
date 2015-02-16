require 'simplecov'
SimpleCov.start

require 'rack/test'
require 'fakeweb'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/snd'

ENV['RACK_ENV'] = 'test'

module Snd
  class Test < Minitest::Test
    include Rack::Test::Methods

    alias_method :silent, :capture_io

    def teardown

    end
  end
end