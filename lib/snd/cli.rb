require 'thor'

module Snd
  class CLI < Thor
    include Thor::Actions

    desc 'start', 'Starts the server in style!'
    def start(*args)
      port = args.include?('-p') ? '' : ' -p 3030'
      args = args.join(' ')
      command = "bundle exec thin -R config.ru start #{port} #{args}"
      run_command(command)
    end

    desc 'stop', 'Stops the thin server'
    def stop
      command = 'bundle exec thin stop'
      run_command(command)
    end

    private

    def run_command(command)
      system(command)
    end

   end
 end