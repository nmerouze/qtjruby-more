module Qt
  module Dsl
    module Widgets
      def lcd_number(*args, &block)
        add_widget Qt::LCDNumber.new(*args), &block
      end
    end
  end
end