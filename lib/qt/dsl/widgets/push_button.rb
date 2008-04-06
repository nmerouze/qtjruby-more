module Qt
  module Dsl
    module Widgets
      def push_button(text, icon = nil, &block)
        icon = Qt::Icon.new(icon) unless icon.nil?
        widget = Qt::PushButton.new(icon, text)
        
        @layouts.first.add_widget(widget)
        block.call(widget) if block_given?
        return widget
      end
    end
  end
end