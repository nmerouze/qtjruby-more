module Qt
  module Dsl
    module Layouts
      def vbox(options = {}, &block)
        add_layout Qt::VBoxLayout.new, &block
      end
    end
  end
end