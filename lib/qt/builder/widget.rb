module Qt
  module Builder
    class Widget
      attr :blocks
      attr_reader :source
      
      def initialize(source, &block)
        @source = source
        @parent = Qt::Builder.layout

        @blocks = []
        add_block(&block) if block_given?
        @parent.add_child(self) unless @parent.nil?
      end
      
      def add_block(&block)
        @blocks << block
      end
      
      def run
        @blocks.each { |b| b.call(@source) }
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @source.send(sym, *args, &block)
        end
    end
  end
end