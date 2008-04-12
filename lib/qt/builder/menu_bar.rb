module Qt
  module Builder
    
    class MenuBar
      attr :blocks
      attr :menus
      attr_accessor :object
      
      def initialize(object, &block)
        @object = object
        @blocks = []
        add_block(&block) if block_given?
        Qt::Builder.current_menu = self
      end
      
      def add_block(&block)
        @blocks << block
      end
      
      def add_menu(menu)
        @menus << menu
      end
      
      def run
        @menus.each do |menu|
          @object.add_menu menu.object
        end

        @block.call(@object) unless @block.nil?
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @object.send(sym, *args, &block)
        end
    end

  end
end