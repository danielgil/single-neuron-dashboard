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
    command = @list_cmd.split(',')
    return from_nexus(command[1], command[2], command[3]) if command[0] == 'nexus'
    return from_command(command[1]) if command[0] == 'command'
    []
  end

  def deploy
    'Command not available' if @deploy_cmd.nil?
  end

  def version
    return 'Command not available' if @version_cmd.nil?
    run_safely(@version_cmd)
  end
end
