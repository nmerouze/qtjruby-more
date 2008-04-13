module Qt
  module Builder
    class MainWindow
      attr :block
      attr_reader :layout
      attr_accessor :menu_bar
      attr_reader :source
      
      def initialize(source, &block)
        @source = source
        @block = block if block_given?
        Qt::Builder.root = self
      end
      
      def layout=(layout)
        @layout = layout
        @source.layout = layout.source
      end
      
      def run
        @block.call(@source)
        @layout.run
        @menu_bar.run unless @menu_bar.nil?
      end
      
      protected
      
        def method_missing(sym, *args, &block)
          @source.send(sym, *args, &block)
        end
    end
  end
end