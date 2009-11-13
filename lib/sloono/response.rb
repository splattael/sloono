require 'forwardable'

module Sloono

  class Response
    extend Forwardable

    attr_reader :status, :text, :characters, :messages, :from, :to, :charge, :deliver_at

    def_delegators :@status, :success?, :error?, :input_error?, :system_error?, :symbol, :fake?

    StatusParser = {
      :status_code  =>  /^(\d{3})$/,
      :status_text  =>  /^(\D[^:]+)$/,
    }

    Parser = {
      :text         =>  /^Text: (.*)/,
      :characters   =>  /^Zeichen: (.*)/,
      :messages     =>  /^SMS: (.*)/,
      :from         =>  /^Absenderkennung: (.*)/,
      :to           =>  /^Ziele: (.*)/,
      :charge       =>  /^Kosten: (.*)/,
      :deliver_at   =>  /^Versenden: (.*)/,
    }

    def parse(text)
      text.gsub!(/\r/, '')

      @status = parse_status!(text)

      if status.success?
        parse_content!(text)
      end
    end

    def self.parse(text)
      new.tap { |response| response.parse(text) }
    end

    private

    def parse_status!(text)
      # TODO ugly
      text.gsub!(StatusParser[:status_code], '')
      status_code = $1
      text.gsub!(StatusParser[:status_text], '')
      status_text = $1
      Status.new(status_code, status_text)
    end

    def parse_content!(text)
      content = Parser.inject({}) do |mapped, (key, regexp)|
        if match = regexp.match(text)
          mapped[key] = match.captures.first
        end
        mapped
      end

      unless content.size == Parser.size
        missing = Parser.keys - content.keys
        raise ArgumentError.new("invalid response text. Missing keys: #{missing.inspect}") # TODO real exception
      end

      # Fix up
      content[:characters]  = content[:characters].to_i
      content[:messages]    = content[:messages].to_i
      content[:to]          = content[:to].split(/,/) # TODO really?
      content[:charge]      = content[:charge].gsub!(/,/, '.').to_f
      content[:deliver_at]  = content[:deliver_at] == 'Sofort' ? nil : Time.at(content[:deliver_at].to_i)

      # key -> @key
      content.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    public

    # Status (code and text) of given Response.
    class Status
      SUCCESS_RANGE = 100..199
      INPUT_ERROR_RANGE = 200..299
      SYSTEM_ERROR_RANGE = 300..399
      FAKE_CODE = 101

      attr_reader :code, :text

      def initialize(code, text)
        @code = code.to_i
        @text = text.to_s.strip
        raise ArgumentError.new("code out of range #{code}") if symbol == :unknown
      end

      def symbol
        case code
        when SUCCESS_RANGE
          :success
        when INPUT_ERROR_RANGE
          :input_error
        when SYSTEM_ERROR_RANGE
          :system_error
        else
          :unknown
        end
      end

      def success?
        symbol == :success
      end

      def fake?
        code == FAKE_CODE
      end

      def input_error?
        symbol == :input_error
      end

      def system_error?
        symbol == :system_error
      end

      def error?
        input_error? || system_error?
      end
    end
  end

end
