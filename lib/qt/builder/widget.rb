module Qt
  module Builder
    class Widget
      attr :blocks
      attr_accessor :layout
      attr_accessor :object
      
      def initialize(object, &block)
        @object = object
        @blocks = []
        add_block(&block) if block_given?
        @parent = Qt::Builder.current_layout
        @parent.add_child(self) unless @parent.nil?
      end
      
      def add_block(&block)
        @blocks << block
      end
      
      def run
        @blocks.each { |b| b.call(@object) }
        
        unless @layout.nil?
          @layout.run
          @object.layout = @layout.object
        end
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @object.send(sym, *args, &block)
        end
    end
  end
end