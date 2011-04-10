require 'spec_helper'

describe Muxilla::Mux do
  before do
    @options = ['nickname', {}]
  end
  it 'responds to nickname' do
    (Muxilla::Mux.new *@options).respond_to?(:nickname).should be
  end
  it 'responds to type' do
    (Muxilla::Mux.new *@options).respond_to?(:type).should be
  end
  describe '.new' do
    it 'requires a nickname and options hash' do
      expect { Muxilla::Mux.new }.to raise_error
    end
    it 'stores the nickname' do
      mux = Muxilla::Mux.new *@options
      mux.nickname.should == 'nickname'
    end
    it 'stores the type' do
      @options.last.merge! :type => :feature
      mux = Muxilla::Mux.new *@options
      mux.type.should == :feature
    end
    it 'stores the update param' do
      @options.last.merge! :update => true
      mux = Muxilla::Mux.new *@options
      mux.update.should be
    end
    it 'stores the id' do
      @options.last.merge! :id => 1234
      mux = Muxilla::Mux.new *@options
      mux.id.should == 1234
    end
    it 'stores the code hash' do
      @options.last.merge! :apps => {'code' => 'foo,bar,garply'}
      mux = Muxilla::Mux.new *@options
      mux.code.should include 'foo'
      mux.code.should include 'bar'
      mux.code.should include 'garply'
    end
    it 'stores the rails hash' do
      @options.last.merge! :apps => {'rails' => 'foo,bar,garply'}
      mux = Muxilla::Mux.new *@options
      mux.rails.should include 'foo'
      mux.rails.should include 'bar'
      mux.rails.should include 'garply'
    end
    it 'stores the resque hash' do
      @options.last.merge! :apps => {'resque' => 'baz,quux'}
      mux = Muxilla::Mux.new *@options
      mux.resque.should include 'baz'
      mux.resque.should include 'quux'
      mux.code.should == []
      mux.rails.should == []
    end
    it 'returns an empty array when no apps options are specified' do
      mux = Muxilla::Mux.new *@options
      mux.code.should == []
      mux.rails.should == []
      mux.resque.should == []
    end
    it 'returns an empty array when an empty apps option is specified' do
      @options.last.merge! :apps => {}
      mux = Muxilla::Mux.new *@options
      mux.code.should == []
      mux.rails.should == []
      mux.resque.should == []
    end
  end
end
