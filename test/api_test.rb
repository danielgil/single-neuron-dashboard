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

      expected = {
              'test-app1' => {'start'   => true,
                              'stop'    => true,
                              'status'  => false,
                              'list'    => false,
                              'deploy'  => false,
                              'version' => false,
                              'log'     => true},
              'test-app2' => {'start'   => true,
                              'stop'    => false,
                              'status'  => true,
                              'list'    => true,
                              'deploy'  => true,
                              'version' => false,
                              'log'     => true}
      }.to_json
      assert_equal last_json, expected
  end

  def test_list_application
    to_test_file({'test-app' => {'list_cmd' => 'nexus,http://nexus.host:8081,com.myorg,myartifact'}})
    get '/list/test-app'
    assert_equal last_json, {'status' => 'Running'}.to_json
  end


end

# Quick copy&paste helper
#      testdata = { 'test-app' => { 'start_cmd'   => 'service tomcat start',
#                                   'stop_cmd'    => 'service tomcat stop',
#                                   'status_cmd'  => 'service tomcat status',
#                                   'list_cmd'    => 'wget http://localhost:8080',
#                                   'deploy_cmd'  => 'puppet apply /tmp/tomcat.pp',
#                                   'version_cmd' => 'cat /opt/tomcat/VERSION',
#                                   'log_file'    => '/opt/tomcat/logs/catalina.out',
#      }}