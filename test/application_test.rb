require 'test_helper'

class ApplicationTest < Snd::Test
  def setup
    @application = Application.new('test')
  end

  def test_start
    # Test for success and failure when running the command
    @application.start_cmd = ':' # Returns 0
    assert_equal @application.start, 'success'
    @application.start_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.start, 'failure'

    # Test that the command is not run if the application is already started
    @application.status_cmd = ':' # Returns 0
    @application.start_cmd = ':' # Returns 0
    assert_equal @application.start, 'application already running'
    @application.status_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.start, 'success'
  end

  def test_stop
    # Test for success and failure when running the command
    @application.stop_cmd = ':' # Returns 0
    assert_equal @application.stop, 'success'
    @application.stop_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.stop, 'failure'

    # Test that the command is not run if the application is already stopped
    @application.status_cmd = ':' # Returns 0
    @application.stop_cmd = ':' # Returns 0
    assert_equal @application.stop, 'success'
    @application.status_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.stop, 'application already stopped'
  end

  def test_status
    # Test for success and failure when running the command
    @application.status_cmd = ':' # Returns 0
    assert_equal @application.status, 'running'
    @application.status_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.status, 'stopped'
  end

  def test_command_not_available
    ['start', 'stop', 'status', 'list', 'deploy', 'version'].each do |action|
      assert_equal @application.send(action), 'command not available'
    end
  end
end