module Qt
  module Dsl
    module Objects
      def action(title = nil, &block)
        build :menu, Qt::Action.new(title, window), &block
      end
      
      def application
        Qt::Application
      end
      
      def tr(text)
        window.tr(text)
      end
    end
  end
end