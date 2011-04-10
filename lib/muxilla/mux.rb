module Muxilla
  class Mux
    attr_accessor :nickname, :type, :update, :id
    def initialize(nickname, options)
      @nickname = nickname
      @type = options[:type]
      @update = options[:update]
      @id = options[:id]
    end

    def apps
      @apps = []
      @apps
    end
  end
end
