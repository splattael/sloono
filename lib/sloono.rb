require 'md5'

require 'sloono/extensions'
require 'sloono/sms'

module Sloono

  def self.new(*args, &block)
    API.new(*args, &block)
  end

  class API
    attr_reader :username, :password

    def initialize(username, password, &block)
      @username = username
      @password = crypt_password(password)

      block.yield_or_eval(self) if block
    end

    def sms(options={}, &block)
      options[:api] = self
      SMS.new(options, &block)
    end

    private

    def crypt_password(password)
      if password =~ /\A[a-zA-Z0-9]{32}\Z/
        password
      else
        MD5.hexdigest(password)
      end
    end
  end

end
