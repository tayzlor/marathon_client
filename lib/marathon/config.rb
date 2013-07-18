module Marathon
  class Config
    attr_accessor :server_url

    def initialize(opts = {})
      @server_url = opts[:marathon_host] || ENV['MARATHON_HOST'] || 'http://localhost:8080'
    end
  end
end