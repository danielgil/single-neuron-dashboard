
class Application
  attr_reader :name
  attr_accessor :status_cmd, :start_cmd, :stop_cmd, :list_cmd, :deploy_cmd, :version_cmd, :log_file

  def initialize(name)
    @name = name
  end

  def status
    return 'Command not available' if @status_cmd.nil?
    system(@status_cmd) ? 'Running' : 'Stopped'
  end

  def start
    return 'Command not available' if @start_cmd.nil?
    unless @status_cmd.nil?
      return 'Application already running' if status == 'Running'
    end

    system(@start_cmd) ? 'Success' : 'Failure'
  end

  def stop
    return 'Command not available' if @stop_cmd.nil?
    unless @status_cmd.nil?
      return 'Application already stopped' if status == 'Stopped'
    end
    system(@stop_cmd) ? 'Success' : 'Failure'
  end

  def list
    return 'Command not available' if @list_cmd.nil?
  end

  def deploy
    return 'Command not available' if @deploy_cmd.nil?
  end

  def version
    return 'Command not available' if @version_cmd.nil?
  end
end
