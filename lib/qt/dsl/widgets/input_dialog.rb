module Qt
  module Dsl
    module Widgets
      def input_dialog(label = nil, title = 'Input Dialog')
        text = Qt::InputDialog.get_text(@window, title, label)
        yield text if !text.nil? && !text.empty? && block_given?
      end
    end
  end
end