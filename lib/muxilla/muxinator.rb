module Muxilla
  class Muxinator < Thor::Group
    include Thor::Actions
    argument :mux, :required => false

    def self.source_root
      File.dirname __FILE__
    end

    def create_tmux_config
      template 'templates/tmux_config.tt', 'output/tmux_config.tmux', :verbose => false
    end
  end
end
