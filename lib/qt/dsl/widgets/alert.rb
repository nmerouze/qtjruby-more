module Qt
  module Dsl
    module Widgets
      def alert(text, title = 'Information')
        dialog = Qt::MessageBox.information(@window, title, text)
        yield if dialog == Qt::MessageBox::StandardButton::Ok && block_given?
      end
    end
  end
end