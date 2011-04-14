module Muxilla
  class Muxinator < Thor::Group
    include Thor::Actions
    argument :mux, :required => false

    def self.source_root
      File.dirname __FILE__
    end

    def create_tmux_config
      template File.expand_path(File.join(File.dirname(__FILE__), 'templates/tmux_config.tt')), '~/tmux_config.tmux', :verbose => false
    end
  end

  class Mux
    attr_accessor :nickname, :type, :update, :id, :code, :rails, :resque
    def initialize nickname, options
      @nickname = nickname
      @type = options[:type]
      @update = options[:update]
      @id = options[:id]
      @code = @rails = @resque = []
      if options[:apps]
        @code = options[:apps]['code'].split ',' if options[:apps]['code']
        @rails = options[:apps]['rails'].split ',' if options[:apps]['rails']
        @resque = options[:apps]['resque'].split ',' if options[:apps]['resque']
      end
    end

    def apps
      # delete this once the call has been removed from the template
      @apps = []
      @apps
    end
  end

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
