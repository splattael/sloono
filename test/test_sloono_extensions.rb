require 'helper'

context "Sloono extensions" do

  context "Proc" do

    context "#yields_or_eval" do
      setup do
        Class.new do
          attr_accessor :var

          def initialize(&block)
            block.yield_or_eval(self)
          end
        end
      end

      asserts("evals") { topic.new { self.var = 1 }.var }.equals(1)
      asserts("yields") { topic.new { |o| o.var = 1 }.var }.equals(1)
    end

  end

end
