module Sloono

  class Response
    attr_reader :status, :text, :characters, :messages, :from, :to, :charge, :deliver_at

    class Status
      SUCCESS_RANGE = 100..199
      INPUT_ERROR_RANGE = 200..299
      SYSTEM_ERROR_RANGE = 300..399
      
      attr_reader :code, :text

      def initialize(code, text)
        @code = code.to_i
        @text = text
        raise ArgumentError.new "code out of range #{code}" if status == :unknown
      end

      def status
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
        status == :success
      end

      def input_error?
        status == :input_error
      end
      
      def system_error?
        status == :system_error
      end

      def error?
        input_error? || system_error?
      end
    end
  end

end
