module Muxilla
  class Muxinate < Thor
    require 'json'
    include Thor::Actions
    desc 'feature TITLE', 'generate a new tmux config from a feature branch'
    method_options :update => :boolean,
      :id => :numeric
    def feature(nickname)
      unless File.exists? File.expand_path('~/.muxilla.conf')
        p "Please run muxilla configure to setup your environment first."
        return
      end
      @mux = Mux.new nickname, options.merge(:type => :feature)
      Muxilla::Muxinator.start [@mux]
    end

    desc 'configure', 'Tell Muxilla about how your dev environment is setup'
    def configure
      configuration = {}
      configuration[:development_dir] = shell.ask "what is your development directory?"
      destination = File.expand_path('~/.muxilla.conf')
      create_file(destination, configuration.to_json, :verbose => false)
    end
  end
end
