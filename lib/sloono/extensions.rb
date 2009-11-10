module Sloono
  module Extensions

    module Proc
      def yield_or_eval(o)
        arity > 0 ? call(o) : o.instance_eval(&self)
      end
    end

  end
end

Proc.class_eval { include Sloono::Extensions::Proc }
