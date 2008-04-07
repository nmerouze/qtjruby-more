module Qt
  module Dsl
    module Widgets
      def menu_bar(&block)
        add_menu Qt::MenuBar.new(@window), &block
      end
    end
  end
end