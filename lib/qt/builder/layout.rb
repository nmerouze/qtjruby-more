module Qt
  module Builder

    class Layout
      attr :block
      attr :children
      attr_accessor :object
      
      def initialize(object, &block)
        @object = object
        @block = block if block_given?
        @children = []
        Qt::Builder.current_layout = self
      end
      
      def add_child(child)
        @children << child
      end
      
      def run
        @block.call(@object) unless @block.nil?
        
        @children.each do |child|
          child.run
          if child.is_a? Qt::Builder::Layout
            @object.add_layout child.object
          else
            @object.add_widget child.object
          end
        end
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @object.send(sym, *args, &block)
        end
    end

  end
end