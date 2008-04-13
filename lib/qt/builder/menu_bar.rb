module Qt
  module Builder
    class MenuBar
      attr :blocks
      attr :children
      attr_accessor :source
      
      def initialize(source, &block)
        @source = source
        @blocks = []
        add_block(&block) if block_given?
        @children = []
        @parent = Qt::Builder.root
        Qt::Builder.root.menu_bar = self
      end
      
      def add_block(&block)
        @blocks << block
      end
      
      def add_child(child)
        @children << child
        @source.add_menu(child.source)
      end
      
      def run
        Qt::Builder.menus << self
        @blocks.each { |b| b.call(@source) }
        @children.each { |child| child.run }
        Qt::Builder.menus.pop
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @source.send(sym, *args, &block)
        end
    end
  end
end