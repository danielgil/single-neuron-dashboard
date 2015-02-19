require 'test_helper'

class ApplicationTest < Snd::Test
  def setup
    @application = Application.new('test')
  end

  def test_start
    # Test for success and failure when running the command
    @application.start_cmd = ':' # Returns 0
    assert_equal @application.start, 'Success'
    @application.start_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.start, 'Failure'

    # Test that the command is not run if the application is already started
    @application.status_cmd = ':' # Returns 0
    @application.start_cmd = ':' # Returns 0
    assert_equal @application.start, 'Application already running'
    @application.status_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.start, 'Success'
  end

  def test_stop
    # Test for success and failure when running the command
    @application.stop_cmd = ':' # Returns 0
    assert_equal @application.stop, 'Success'
    @application.stop_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.stop, 'Failure'

    # Test that the command is not run if the application is already stopped
    @application.status_cmd = ':' # Returns 0
    @application.stop_cmd = ':' # Returns 0
    assert_equal @application.stop, 'Success'
    @application.status_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.stop, 'Application already stopped'
  end

  def test_status
    # Test for success and failure when running the command
    @application.status_cmd = ':' # Returns 0
    assert_equal @application.status, 'Running'
    @application.status_cmd = 'doesnotexist' # Returns non-zero
    assert_equal @application.status, 'Stopped'
  end

  def test_command_not_available
    ['start', 'stop', 'status', 'list', 'deploy', 'version'].each do |action|
      assert_equal @application.send(action), 'Command not available'
    end
  end
end