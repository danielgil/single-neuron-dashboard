require 'snd/lister'
require 'open3'

class Application
  include Lister
  attr_reader :name

  # Features of the application
  attr_accessor :status_cmd, :start_cmd, :stop_cmd, :list_cmd, :deploy_cmd, :version_cmd, :log_file, :log_clients
  # Status
  attr_accessor :current_version, :current_status, :available_versions

  def initialize(name)
    @name = name
    @lister = nil
    @log_clients = []
  end

  def status
    return 'command not available' if @status_cmd.nil?
    system(@status_cmd) ? 'running' : 'stopped'
  end

  def start
    return 'command not available' if @start_cmd.nil?
    unless @status_cmd.nil?
      return 'application already running' if status == 'running'
    end

    system(@start_cmd) ? 'success' : 'failure'
  end

  def stop
    return 'command not available' if @stop_cmd.nil?
    unless @status_cmd.nil?
      return 'application already stopped' if status == 'stopped'
    end
    system(@stop_cmd) ? 'success' : 'failure'
  end

  def list
    return 'command not available' if @list_cmd.nil?
    command = @list_cmd.split(',')
    return from_nexus(command[1], command[2], command[3]) if command[0] == 'nexus'
    return from_command(command[1]) if command[0] == 'command'
    []
  end

  def deploy
    'command not available' if @deploy_cmd.nil?
  end

  def version
    return 'command not available' if @version_cmd.nil?
    run_safely(@version_cmd)
  end
end
