module Muxilla
  class Mux
    attr_accessor :nickname, :type, :update, :id, :code, :rails, :resque
    def initialize(nickname, options)
      @nickname = nickname
      @type = options[:type]
      @update = options[:update]
      @id = options[:id]
      @code = @rails = @resque = []
      @code = options[:code].split(',') if options[:code]
      @rails = options[:rails].split(',') if options[:rails]
      @resque = options[:resque].split(',') if options[:resque]
    end

    def apps
      @apps = []
      @apps
    end
  end
end
