module Qt
  module Dsl
    module Widgets
      def alert(text = nil, title = nil)
        dialog = Qt::MessageBox.information(@window, title, text)
        yield if dialog == Qt::MessageBox::StandardButton::Ok && block_given?
      end
      
      def input_dialog(label = nil, title = 'Input Dialog')
        text = Qt::InputDialog.get_text(@window, title, label)
        yield text if !text.nil? && !text.empty? && block_given?
      end
      
      def lcd_number(*args, &block)
        Qt::Builder::Widget.new(Qt::LCDNumber.new(*args), &block)
      end
      
      def list_box(&block)
        Qt::Builder::Widget.new(Qt::ListWidget.new, &block)
      end
      
      def menu_bar(&block)
        Qt::Builder::MenuBar.new(Qt::MenuBar.new(@window), &block)
      end
      
      def menu(title = nil, &block)
        Qt::Builder::Menu.new(Qt::Menu.new(title), &block)
      end
      
      def push_button(title = nil, icon = nil, &block)
        icon = Qt::Icon.new(icon) unless icon.nil?
        build :widget, Qt::PushButton.new(title, icon), &block
      end
      
      def text_edit(&block)
        Qt::Builder::Widget.new(Qt::TextEdit.new, &block)
      end
    end
  end
end