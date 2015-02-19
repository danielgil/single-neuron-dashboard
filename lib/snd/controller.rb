require 'yaml'
require 'snd/application'

class Controller

  attr_reader :apps
  attr_reader :list
  def initialize(configfile='conf/applications.yaml')
    @apps = {}

    @config = YAML.load_file(configfile)

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
    list_apps

  end

  def list_apps
    @list = {}
    @apps.each do |name,app|
      @list[name] = {}
      @list[name]['start'] = !app.start_cmd.nil?
      @list[name]['stop'] = !app.stop_cmd.nil?
      @list[name]['status'] = !app.status_cmd.nil?
      @list[name]['list'] = !app.list_cmd.nil?
      @list[name]['deploy'] = !app.deploy_cmd.nil?
      @list[name]['version'] = !app.version_cmd.nil?
      @list[name]['log'] = !app.log_file.nil?
    end
  end

end
