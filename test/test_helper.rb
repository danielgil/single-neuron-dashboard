require 'simplecov'
SimpleCov.start

require 'rack/test'
require 'fakeweb'
require 'minitest/autorun'
require 'minitest/pride'
require 'json_spec'
require 'faker'

require_relative '../lib/snd'

ENV['RACK_ENV'] = 'test'

module Snd
  class Test < Minitest::Test
    include Rack::Test::Methods
    alias_method :silent, :capture_io

    def app
      Sinatra::Application.new
    end

    def teardown
      File.delete('conf/test.yaml') if File.exist?('conf/test.yaml')
    end

    def last_json
      last_response.body
    end

    def to_test_file(hash)
      File.delete('conf/test.yaml') if File.exist?('conf/test.yaml')
      File.open('conf/test.yaml', 'w') do |file|
        file.write hash.to_yaml
      end
      app.settings.controller = Controller.new('conf/test.yaml')
    end


  end
end