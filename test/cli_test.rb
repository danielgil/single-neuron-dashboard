require 'test_helper'

class CliTest < Snd::Test
  def setup

  end

  def app
    Sinatra::Application
  end

  def test_test
    get '/'
    assert_equal 200, last_response.status
  end
end