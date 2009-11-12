module Sloono
  module Extensions

    module Proc
      def yield_or_eval(o)
        arity > 0 ? call(o) : o.instance_eval(&self)
      end
    end

    module Object
      unless respond_to?(:tap)
        def tap(*args, &block)
          block.call(self, *args)
          self
        end
      end
    end

  end
end

Proc.class_eval { include Sloono::Extensions::Proc }
Object.class_eval { include Sloono::Extensions::Object }
