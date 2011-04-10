module Muxilla
  class Mux
    attr_accessor :nickname, :type, :update, :id, :code, :rails, :resque
    def initialize(nickname, options)
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
      @apps = []
      @apps
    end
  end
end
