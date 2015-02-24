require 'sinatra'
require 'sinatra/json'
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

get '/log/:application' do
  "test"
end

get '/export/:application' do
  "test"
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
