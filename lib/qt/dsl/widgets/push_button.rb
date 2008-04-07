module Qt
  module Dsl
    module Widgets
      def push_button(text, icon = nil, &block)
        icon = Qt::Icon.new(icon) unless icon.nil?
        add_widget Qt::PushButton.new(icon, text), &block
      end
    end
  end
end