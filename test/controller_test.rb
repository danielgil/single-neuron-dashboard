require 'test_helper'

class ControllerTest < Snd::Test

  def test_configfile
    File.delete('conf/applications.yaml') if File.exist?('conf/applications.yaml')
    File.open('conf/applications.yaml', 'w') do |file|
      testdata = { 'first-app' => { 'start_cmd'   => 'service tomcat start',
                                    'stop_cmd'    => 'service tomcat stop',
                                    'status_cmd'  => 'service tomcat status',
                                    'list_cmd'    => 'wget http://localhost:8080',
                                    'deploy_cmd'  => 'puppet apply /tmp/tomcat.pp',
                                    'version_cmd' => 'cat /opt/tomcat/VERSION',
                                    'log_file'    => '/opt/tomcat/logs/catalina.out',
      }}.to_yaml
      file.write testdata
    end

    assert_raises Errno::ENOENT do
      @controller = Controller.new('conf/doesntexist.yaml')
    end

    @controller = Controller.new('conf/applications.yaml')

    assert_equal @controller.apps['first-app'].name, 'first-app'
    assert_equal @controller.apps['first-app'].start_cmd, 'service tomcat start'
    assert_equal @controller.apps['first-app'].log_file, '/opt/tomcat/logs/catalina.out'

  end

end