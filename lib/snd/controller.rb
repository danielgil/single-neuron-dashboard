require 'yaml'
require 'snd/application'

class Controller

  attr_reader :apps

  def initialize
    @apps = {}
    @config = YAML.load_file('conf/applications.yaml')

    @config.each do |key,value|
      @apps[key] = Application.new(key)
      @apps[key].start_cmd = value['start_cmd']     if value.has_key? 'start_cmd'
      @apps[key].stop_cmd = value['stop_cmd']       if value.has_key? 'stop_cmd'
      @apps[key].status_cmd = value['status_cmd']   if value.has_key? 'status_cmd'
      @apps[key].list_cmd = value['list_cmd']       if value.has_key? 'list_cmd'
      @apps[key].deploy_cmd = value['deploy_cmd']   if value.has_key? 'deploy_cmd'
      @apps[key].version_cmd = value['version_cmd'] if value.has_key? 'version_cmd'
      @apps[key].log_file = value['log_file']       if value.has_key? 'log_file'
    end
    p @apps.inspect
  end

end
