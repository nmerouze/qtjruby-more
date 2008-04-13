module Qt
  module Builder
    class Layout
      attr :blocks
      attr :children
      attr_reader :source
      attr :parent
      
      def initialize(source, &block)
        @source = source
        @blocks = []
        add_block(&block) if block_given?
        @parent = Qt::Builder.layout
        @children = []

        if @parent.nil?
          Qt::Builder.root.layout = self
        else
          @parent.add_child(self)
        end
      end
      
      def add_block(&block)
        @blocks << block
      end
      
      def add_child(child)
        @children << child
        
        if child.is_a? Qt::Builder::Layout
          @source.add_layout(child.source)
        else
          @source.add_widget(child.source)
        end
      end
      
      def run
        Qt::Builder.layouts << self
        @blocks.each { |b| b.call(@source) }
        @children.each { |child| child.run }
        Qt::Builder.layouts.pop
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @source.send(sym, *args, &block)
        end
    end
  end
end