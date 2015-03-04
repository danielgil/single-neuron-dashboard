require 'sinatra'
require 'sinatra/json'
require 'sinatra/streaming'
require 'snd/controller'



set :root, Dir.pwd
set :public_folder, File.join(settings.root, 'public')
set :controller, Controller.new


get '/' do
  File.read('public/index.html')
end

get '/status/:application' do
  app = settings.controller.apps[params[:application]]
  return json :status => 'App not found' if app.nil?
  json :status => app.status
end

get '/start/:application' do
  app = settings.controller.apps[params[:application]]
  return json :status => 'App not found' if app.nil?
  json :status => app.start
end

get '/stop/:application' do
  app = settings.controller.apps[params[:application]]
  return json :status => 'App not found' if app.nil?
  json :status => app.stop
end

get '/list' do
  json settings.controller.list
end

get '/list/:application' do
  app = settings.controller.apps[params[:application]]
  return json :status => 'App not found' if app.nil?
  json :versions => app.list
end

get '/version/:application' do
  app = settings.controller.apps[params[:application]]
  return json :version => 'App not found' if app.nil?
  json :version => app.version
end

get '/deploy/:application' do
  "test"
end

get '/log/:application', provides: 'text/event-stream' do
  stream(:keep_open) do |out|
    app = settings.controller.apps[params[:application]]
    app.log_clients << out
    out.callback { app.log_clients.delete out }
    out.errback { app.log_clients.delete out }
  end
end

# TODO: remove this and create a thread or use EM to stream the log file
get '/broadcast/:application' do
  app = settings.controller.apps[params[:application]]
  app.log_clients.each do |client|
    client << "test + #{rand}"
  end
end

get '/export/:application' do
  app = settings.controller.apps[params[:application]]
  return json :log => 'App not found' if app.nil?
  return json :log => 'Log file not found' unless File.file?(app.log_file) and File.stat(app.log_file).readable?
  send_file app.log_file, :filename => File.basename(app.log_file), :type => 'text/plain'
end

not_found do
  json :status => 'Invalid request'
end

def development?
  ENV['RACK_ENV'] == 'development'
end

def production?
  ENV['RACK_ENV'] == 'production'
end
