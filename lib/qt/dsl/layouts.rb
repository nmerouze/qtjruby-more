module Qt
  module Dsl
    module Layouts
      def hbox(options = {}, &block)
        layout = Qt::HBoxLayout.new
        layout.margin = options[:margin] if options[:margin]
        
        build :layout, layout, &block
      end
      
      def vbox(options = {}, &block)
        layout = Qt::VBoxLayout.new
        layout.margin = options[:margin] if options[:margin]
        
        build :layout, layout, &block
      end
    end
  end
end