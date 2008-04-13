module Qt
  module Builder
    class Menu
      attr :blocks
      attr :children
      attr_reader :source
      attr :parent
      
      def initialize(source, &block)
        @source = source
        @blocks = []
        add_block(&block) if block_given?
        @parent = Qt::Builder.menu
        @children = []
        
        @parent.add_child(self)
      end
      
      def add_block(&block)
        @blocks << block
      end
      
      def add_child(child)
        @children << child
        
        if child.source.is_a? Qt::Menu
          @source.add_menu(child.source)
        else
          @source.add_action(child.source)
        end
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