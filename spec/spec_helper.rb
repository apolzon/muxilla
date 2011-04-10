$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'thor'
require 'thor/group'
require 'muxilla'
require 'rspec'
require 'stringio'
ARGV.clear

Rspec.configure do |config|

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end

  def tmux_config
    File.expand_path File.join(File.dirname(__FILE__), '..', 'output', 'tmux_config.tmux')
  end

  config.before :each do
    if File.exists? tmux_config
      File.delete tmux_config
    end
  end
end
