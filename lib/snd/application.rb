
class Application
  attr_accessor :name, :status_cmd, :start_cmd, :stop_cmd, :list_cmd, :deploy_cmd, :version_cmd, :log_file

  def initialize(name)
    @name = name
  end

  def status
    return 'Command not available' if @status_cmd.nil?
    system(@status_cmd) ? 'Running' : 'Stopped'
  end

  def start
    return 'Command not available' if @start_cmd.nil?
    system(@start_cmd) ? 'Success' : 'Failure'
  end

  def stop
    return 'Command not available' if @stop_cmd.nil?
    system(@stop_cmd) ? 'Success' : 'Failure'
  end

  def list

  end

  def deploy

  end
end
