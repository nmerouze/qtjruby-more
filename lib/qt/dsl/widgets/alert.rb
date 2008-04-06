module Qt
  module Dsl
    module Widgets
      def alert(text, title = 'Information')
        Qt::MessageBox.information(@window, title, text)
      end
    end
  end
end