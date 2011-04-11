module Muxilla
  class Muxinate < Thor
    require 'json'
    include Thor::Actions

    desc 'configure', 'Tell Muxilla about how your dev environment is setup'
    def configure
      configuration = {}
      configuration[:development_dir] = shell.ask "what is your development directory?"
      destination = File.expand_path('~/.muxilla.conf')
      create_file(destination, configuration.to_json, :verbose => false)
    end

    desc 'feature TITLE', 'generate a new tmux config from a feature branch'
    method_options :update => :boolean,
      :id => :numeric,
      :apps => :hash
    def feature nickname
      if !check_config
        return
      end
      muxinator_it :feature, nickname, options
    end

    desc 'bug TITLE', 'generate a new tmux config from a bug branch'
    method_options :update => :boolean,
      :id => :numeric,
      :apps => :hash
    def bug nickname
      if !check_config
        return
      end
      muxinator_it :bug, nickname, options
    end

    desc 'chore TITLE', 'generate a new tmux config from a bug branch'
    method_options :update => :boolean,
      :id => :numeric,
      :apps => :hash
    def chore nickname
      if !check_config
        return
      end
      muxinator_it :chore, nickname, options
    end

    private
    def check_config
      unless File.exists? File.expand_path('~/.muxilla.conf')
        p "Please run muxilla configure to setup your environment first."
        return false
      end
      true
    end

    def muxinator_it type, nickname, options
      @mux = Mux.new nickname, options.merge(:type => type)
      Muxilla::Muxinator.start [@mux]
    end
  end
end
