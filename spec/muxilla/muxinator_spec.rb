require 'spec_helper'

describe Muxilla::Muxinator do
  it 'outputs a .tmux file' do
    Muxilla::Muxinator.start([Muxilla::Mux.new('foo', {})])
    File.exists?(tmux_config).should be
  end
end
