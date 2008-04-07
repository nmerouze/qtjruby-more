module Qt
  module Dsl
    module Layouts
      def hbox(options = {}, &block)
        add_layout Qt::HBoxLayout.new, &block
      end
    end
  end
end