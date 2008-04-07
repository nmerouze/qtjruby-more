module Qt
  module Dsl
    module Widgets
      def text_edit(&block)
        add_widget Qt::TextEdit.new, &block
      end
    end
  end
end