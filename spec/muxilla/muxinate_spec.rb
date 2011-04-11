require 'spec_helper'

describe Muxilla::Muxinate do
  describe 'help' do
    it 'outputs information about available commands' do
      output = capture { Muxilla::Muxinate.start }
      output.should match /feature/
      output.should match /configure/
    end
    it 'describes feature' do
      output = capture { Muxilla::Muxinate.start }
      output.should match /generate a new tmux config from a feature branch/
    end
    it 'describes bug' do
      output = capture { Muxilla::Muxinate.start }
      output.should match /generate a new tmux config from a bug branch/
    end
    it 'describes configure' do
      output = capture { Muxilla::Muxinate.start }
      output.should match /how your dev environment is setup/
    end
  end

  describe 'tasks' do
    describe '#configure' do
      before do
        $stdin.stub :gets => '~/dev'
        if File.exists? File.expand_path('~/.muxilla.conf')
          File.delete File.expand_path('~/.muxilla.conf')
        end
      end
      it 'prompts for the users development directory' do
        $stdin.should_receive(:gets).and_return('~/dev')
        output = capture { Muxilla::Muxinate.start ['configure'] }
        output.should match /what is your development directory/
          File.read(File.expand_path '~/.muxilla.conf').should match /~\/dev/
      end
      it 'outputs a muxilla.conf file in the users home directory' do
        capture { Muxilla::Muxinate.start ['configure'] }
        File.exists?(File.expand_path '~/.muxilla.conf').should be
      end
      after do
        File.delete(File.expand_path '~/.muxilla.conf')
      end
    end

    describe '#feature' do
      it 'requires configuration' do
        Muxilla::Muxinator.should_not_receive :start
        output = capture { Muxilla::Muxinate.start ['feature', 'foo'] }
        output.should match /please run muxilla configure to setup/i
      end
      context 'after configuring' do
        before do
          $stdin.stub :gets => '~/dev'
          capture { Muxilla::Muxinate.start ['configure'] }
        end
        it 'calls the muxilla generator' do
          Muxilla::Muxinator.should_receive :start
          Muxilla::Muxinate.start ['feature', 'foo']
        end
        it 'uses a feature branchname' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.type.should == :feature
          end
          Muxilla::Muxinate.start ['feature', 'foo']
        end
        it 'uses the nickname' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.nickname.should == 'foo'
          end
          Muxilla::Muxinate.start ['feature', 'foo']
        end
        it 'respects the update parameter' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.update.should be
          end
          Muxilla::Muxinate.start ['feature', 'foo', '--update']
        end
        it 'respects the id parameter' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.id.should == 1234
          end
          Muxilla::Muxinate.start ['feature', 'foo', '--id', 1234]
        end
        it 'respects the code parameter' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.code.should == ['fumanchu']
          end
          Muxilla::Muxinate.start ['feature', 'foo', '--apps=code:fumanchu']
        end
        it 'respects the rails parameter' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.rails.should == ['fumanchu']
          end
          Muxilla::Muxinate.start ['feature', 'foo', '--apps=rails:fumanchu']
        end
        it 'respects the resque parameter' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.resque.should == ['fumanchu']
          end
          Muxilla::Muxinate.start ['feature', 'foo', '--apps=resque:fumanchu']
        end
        it 'generates a config containing our branch nickname' do
          Muxilla::Muxinate.start ['feature', 'foo']
          File.read(tmux_config).should match 'foo'
        end
        after do
          File.delete(File.expand_path '~/.muxilla.conf')
        end
      end
    end

    describe '#bug' do
      before do
        File.delete(File.expand_path '~/.muxilla.conf') if File.exists?(File.expand_path '~/.muxilla.conf')
      end
      it 'requires configuration' do
        Muxilla::Muxinator.should_not_receive :start
        output = capture { Muxilla::Muxinate.start ['bug', 'foo'] }
        output.should match /please run muxilla configure to setup/i
      end
      context 'after configuring' do
        before do
          $stdin.stub :gets => '~/dev'
          capture { Muxilla::Muxinate.start ['configure'] }
        end
        it 'calls the muxilla generator' do
          Muxilla::Muxinator.should_receive :start
          Muxilla::Muxinate.start ['bug', 'foo']
        end
        it 'uses a feature branchname' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.type.should == :bug
          end
          Muxilla::Muxinate.start ['bug', 'foo']
        end
      end
    end

    describe '#chore' do
      before do
        File.delete(File.expand_path '~/.muxilla.conf') if File.exists?(File.expand_path '~/.muxilla.conf')
      end
      it 'requires configuration' do
        Muxilla::Muxinator.should_not_receive :start
        output = capture { Muxilla::Muxinate.start ['chore', 'foo'] }
        output.should match /please run muxilla configure to setup/i
      end
      context 'after configuring' do
        before do
          $stdin.stub :gets => '~/dev'
          capture { Muxilla::Muxinate.start ['configure'] }
        end
        it 'calls the muxilla generator' do
          Muxilla::Muxinator.should_receive :start
          Muxilla::Muxinate.start ['chore', 'foo']
        end
        it 'uses a feature branchname' do
          Muxilla::Muxinator.should_receive(:start).with do |args|
            mux = args.first
            mux.type.should == :chore
          end
          Muxilla::Muxinate.start ['chore', 'foo']
        end
      end
    end
  end
end
