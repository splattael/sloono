require 'typhoeus'
require 'uri'

module Sloono
  class Request
    DEFAULT_BASE_URI = "http://www.sloono.de/"

    class << self
      attr_reader :base_uri
    end
    @base_uri = DEFAULT_BASE_URI

    attr_reader :base_uri

    def initialize(base_uri=self.class.base_uri)
      @base_uri = base_uri
    end

    def sms(params={})
      request("/API/httpsms.php", params)
    end

    def self.sms(params={})
      request = new(params.delete(:base_uri) || base_uri)
      request.sms(params)
    end

    private

    def request(path, params={})
      url = ::URI.parse(base_uri)
      url.path = path
      response = Typhoeus::Request.post(url.to_s, :params => params)
      Response.parse(response.body)
    end
  end
end
