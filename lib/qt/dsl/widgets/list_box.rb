module Qt
  module Dsl
    module Widgets
      def list_box(&block)
        add_widget Qt::ListWidget.new, &block
      end
    end
  end
end