module Qt
  module Dsl
    module Objects
      def action(title = nil, &block)
        add_menu Qt::Action.new(title, @window), &block
      end
    end
  end
end