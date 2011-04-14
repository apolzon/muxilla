require 'spec_helper'

describe Muxilla::Muxinator do
  it 'outputs a .tmux file' do
    Muxilla::Muxinator.start [Muxilla::Mux.new('foo', {:apps => {'code' => 'foo,bar'}})]
    File.exists?(tmux_config).should be
    File.read(tmux_config).should match /foo/
    File.read(tmux_config).should match /bar/
  end
end
