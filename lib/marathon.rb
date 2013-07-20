
__LIB_DIR__ = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift __LIB_DIR__ unless $LOAD_PATH.include?(__LIB_DIR__)

require "faraday"
require "multi_json"

require "marathon/version"
require "marathon/config"
require "marathon/app"

module Marathon

  def self.list_apps
    res = connection.get do |req|
      req.url '/v1/apps'
    end
    MultiJson.load(res.body)
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure(opts)
    @config = Config.new(opts)
  end

  def self.connection
    @connection ||= Faraday.new(:url => config.server_url) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.adapter Faraday.default_adapter
    end
  end
end
