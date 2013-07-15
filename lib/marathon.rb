
__LIB_DIR__ = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift __LIB_DIR__ unless $LOAD_PATH.include?(__LIB_DIR__)

require "faraday"
require "multi_json"

require "marathon/version"
require "marathon/app"

module Marathon

  def self.list_apps
    res = Marathon.connection.get do |req|
      req.url '/v1/apps'
    end
    MultiJson.load(res.body)
  end

  # TODO how to configure this
  def self.endpoint_url
    "http://localhost:8080"
  end

  def self.connection
    @connection ||= Faraday.new(url: Marathon.endpoint_url) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.adapter Faraday.default_adapter
    end
  end
end
