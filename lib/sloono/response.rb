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
        if success?
          :success
        elsif input_error?
          :input_error
        elsif system_error?
          :system_error
        else
          :unknown
        end
      end

      def success?
        SUCCESS_RANGE.include?(code)  
      end

      def input_error?
        INPUT_ERROR_RANGE.include?(code)
      end
      
      def system_error?
        SYSTEM_ERROR_RANGE.include?(code)
      end

      def error?
        input_error? || system_error?
      end
    end
  end

end
