module Qt
  module Dsl
    module Layouts
      def vbox(options = {}, &block)
        layout = Qt::VBoxLayout.new
        layout.margin = options[:margin] if options[:margin]
        
        add_layout layout, &block
      end
    end
  end
end