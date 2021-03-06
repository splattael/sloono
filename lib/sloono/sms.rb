module Sloono

  class SMS
    FROM_RANGE = 1..5
    TYPES = %w(0 1 2 3 discount basic lite pro flash)

    attr_reader :api, :response

    def initialize(options={}, &block)
      @api = options[:api]
      @response = nil

      from        options[:from] || 1
      to          options[:to]
      text        options[:text] || ""
      type        options[:type] || :discount
      deliver_at  options[:deliver_at]

      block.yield_or_eval(self) if block
    end

    def from(arg=nil)
      if arg
        arg = arg.to_i
        raise ArgumentError.new("must be between 1..5") unless FROM_RANGE.include?(arg)
        @from = arg
      end
      @from
    end

    def to(arg=nil)
      @to = Array(arg) if arg
      @to ||= []
    end

    def text(arg=nil)
      @text = arg.to_s.strip if arg
      @text
    end

    def type(arg=nil)
      if arg
        arg = arg.to_s.downcase
        raise ArgumentError.new("must be one of [#{TYPES.join(', ')}]") unless TYPES.include?(arg)
        @type = arg
      end
      @type
    end

    def deliver_at(arg=nil)
      @deliver_at = arg.to_i if arg
      @deliver_at
    end

    def sent?
      !!@response
    end

    def send!
      request!("send")
    end

    def info!
      request!("info")
    end

    private

    def request!(action)
      params = {
        :user       =>  @api.username,
        :password   =>  @api.password,
        :action     =>  action,
        :typ        =>  type,
        :timestamp  =>  deliver_at || 0,
        :text       =>  text,
        :from       =>  from,
        :to         =>  to.join(","),
        :return     =>  "text"
      }

      @response = Request.sms(params)
    end
  end

end
