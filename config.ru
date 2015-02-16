require_relative 'lib/snd'

configure do

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

run Sinatra::Application