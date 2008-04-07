module Qt
  module Dsl
    module Layouts
      def hbox(options = {}, &block)
        layout = Qt::HBoxLayout.new
        layout.margin = options[:margin] if options[:margin]
        
        add_layout layout, &block
      end
    end
  end
end