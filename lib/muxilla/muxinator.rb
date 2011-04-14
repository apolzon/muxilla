module Muxilla
  class Muxinator < Thor::Group
    include Thor::Actions
    argument :mux

    def self.source_root
      `echo $GEM_HOME`.chomp + "/gems/muxilla-0.0.1/lib/muxilla"
    end

    def create_tmux_config
      template 'templates/tmux_config.tt', '~/tmux_config.tmux', :verbose => false
    end
  end
end
