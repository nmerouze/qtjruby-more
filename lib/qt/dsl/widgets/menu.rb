module Qt
  module Dsl
    module Widgets
      def menu(title = nil, &block)
        add_menu Qt::Menu.new(title), &block
      end
    end
  end
end