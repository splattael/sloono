require 'md5'

module Sloono

  def self.new(*args, &block)
    API.new(*args, &block)
  end

  class API
    attr_reader :username, :password

    def initialize(username, password, &block)
      @username = username
      @password = crypt_password(password)

      if block
        block.arity > 0 ? block.call(self) : instance_eval(&block)
      end
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

  class SMS
    def initialize(options={}, &block)
      @api = options[:api]

      from      options[:from] || 1
      to        options[:to]
      text      options[:text] || ""
      type      options[:type] || :discount
      timestamp options[:timestamp] || 0
      action    options[:action]
    end

    def from(arg=nil)
      if arg
        arg = arg.to_i
        raise ArgumentError.new "must be between 1..5" unless (1..5).include?(arg)
        @from = arg
      end
      @from
    end

    def to(arg=nil)
      @to = arg if arg
      @to
    end

    def text(arg=nil)
      @text = arg if arg
      @text
    end

    def type(arg=nil)
      @type = arg if arg
      @type
    end

    def timestamp(arg=nil)
      @timestamp = arg.to_i if arg
      @timestamp
    end

    def action(arg=nil)
      @action = arg if arg
      @action
    end
  end

end
