require_relative 'lib/snd'
require 'sprockets'
require 'sass'

configure do

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/fonts'
  environment.append_path 'assets/images'
  environment.css_compressor = :scss
  run environment
end

run Sinatra::Application