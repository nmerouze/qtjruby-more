module Qt
  module Mapper
    module ClassMethods
      
      def signal(nb = 0)
        Java::JavaClass.for_name("org.qtjruby.qtjambi.jruby.Signal#{nb}").ruby_class.new
      end

      def connect(signal, slot, &block)
        b = block_given? ? block : nil
        Java::JavaClass.for_name("org.qtjruby.qtjambi.jruby.Signals").ruby_class.connect(signal, slot, b)
      end
      
      # def event(event, &block)
      #   Qt.connect(event, , &block)
      # end
      
    end
  end
end