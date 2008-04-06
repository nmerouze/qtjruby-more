module Qt
  module Dsl
    module Widgets
      def lcd_number(*args, &block)
        widget = Qt::LCDNumber.send :new, *args
        @layouts.first.add_widget(widget)
        block.call(widget) if block_given?
        return widget
      end
    end
  end
end