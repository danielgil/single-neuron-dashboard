require 'test_helper'

class ApiTest < Snd::Test

  def test_main_page
    get '/'
    assert_equal 200, last_response.status
  end

  def test_status
    to_test_file({ 'test-app' => {}})
    get '/status/test-app'
    assert_equal last_json, {'status' => 'Command not available'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => ':' }}) # Returns zero
    get '/status/test-app'
    assert_equal last_json, {'status' => 'Running'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => 'notacommand' }}) # Returns non-zero
    get '/status/test-app'
    assert_equal last_json, {'status' => 'Stopped'}.to_json
  end

  def test_start
    to_test_file({ 'test-app' => {}})
    get '/start/test-app'
    assert_equal last_json, {'status' => 'Command not available'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => ':',
                                   'start_cmd'   => ':'}})
    get '/start/test-app'
    assert_equal last_json, {'status' => 'Application already running'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => 'notacommand',
                                   'start_cmd'   => ':'}})
    get '/start/test-app'
    assert_equal last_json, {'status' => 'Success'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => 'notacommand',
                                   'start_cmd'   => 'notacommand'}})
    get '/start/test-app'
    assert_equal last_json, {'status' => 'Failure'}.to_json
  end

  def test_stop
    to_test_file({ 'test-app' => {}})
    get '/stop/test-app'
    assert_equal last_json, {'status' => 'Command not available'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => 'notacommand',
                                   'stop_cmd'   => ':'}})
    get '/stop/test-app'
    assert_equal last_json, {'status' => 'Application already stopped'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => ':',
                                   'stop_cmd'   => ':'}})
    get '/stop/test-app'
    assert_equal last_json, {'status' => 'Success'}.to_json

    to_test_file({ 'test-app' => { 'status_cmd'  => ':',
                                   'stop_cmd'    => 'notacommand'}})
    get '/stop/test-app'
    assert_equal last_json, {'status' => 'Failure'}.to_json
  end

  def test_list
      testdata = {  'test-app1' => { 'start_cmd'   => 'service tomcat start',
                                   'stop_cmd'    => 'service tomcat stop',
                                   'log_file'    => '/opt/tomcat/logs/catalina.out',
                    },
                    'test-app2' => { 'start_cmd'   => 'service tomcat start',
                                   'status_cmd'  => 'service tomcat status',
                                   'list_cmd'    => 'wget http://localhost:8080',
                                   'deploy_cmd'  => 'puppet apply /tmp/tomcat.pp',
                                   'log_file'    => '/opt/tomcat/logs/catalina.out'}}
      to_test_file testdata
      get '/list'

      expected = [{'name'    =>  'test-app1',
                  'options'  => {'start'   => true,
                                 'stop'    => true,
                                 'status'  => false,
                                 'list'    => false,
                                 'deploy'  => false,
                                 'version' => false,
                                 'log'     => true}
                  },
                  {'name'    =>  'test-app2',
                   'options' => {'start'   => true,
                                 'stop'    => false,
                                 'status'  => true,
                                 'list'    => true,
                                 'deploy'  => true,
                                 'version' => false,
                                 'log'     => true}
                  }].to_json
      assert_equal last_json, expected
  end

  def test_list_application
    #to_test_file({'test-app' => {'list_cmd' => 'nexus,http://nexus.host:8081,com.myorg,myartifact'}})
    to_test_file({'test-app' => {'list_cmd' => 'command,echo -n "1.0 2.0 3.0 4.0 5.0"'}})
    get '/list/test-app'
    assert_equal last_json, {'versions' => ['1.0', '2.0', '3.0', '4.0', '5.0']}.to_json
  end

  def test_version
    to_test_file({ 'test-app' => {}})
    get '/version/test-app'
    assert_equal last_json, {'version' => 'Command not available'}.to_json

    to_test_file({'test-app' => {'version_cmd' => 'echo -n "4.10.0-SNAPSHOT"'}})
    get '/version/test-app'
    assert_equal last_json, {'version' => '4.10.0-SNAPSHOT'}.to_json

    to_test_file({'test-app' => {'version_cmd' => 'notacommand'}})
    get '/version/test-app'
    assert_equal last_json, {'version' => 'Failure'}.to_json
  end

  def test_export
    to_test_file({'test-app' => {'log_file' => 'conf/test.log'}})

    File.delete('conf/test.log') if File.exist?('conf/test.log')
    get '/export/test-app'
    assert_equal last_json, {'log' => 'Log file not found'}.to_json

    File.open('conf/test.log', 'w+') do |file|
      100.times do
        file.write "#{Faker::Lorem.sentence}\n"
      end
    end
    get '/export/test-app'
    assert_equal last_response['Content-Type'], 'text/plain;charset=utf-8'
    assert_equal last_response['Content-Disposition'], 'attachment; filename="test.log"'
    File.delete('conf/test.log') if File.exist?('conf/test.log')
  end

  def test_log
    to_test_file({'test-app' => {'log_file' => 'conf/test.log'}})
    File.delete('conf/test.log') if File.exist?('conf/test.log')
    File.open('conf/test.log', 'w+') do |file|
      100.times do
        file.write "#{Faker::Lorem.sentence}\n"
      end
    end
    get '/log/test-app'

    File.delete('conf/test.log') if File.exist?('conf/test.log')
  end
end

