module Qt
  module Dsl
    module Layouts
      def hbox(options = {}, &block)
        layout = Qt::HBoxLayout.new
        layout.margin = options[:margin] if options[:margin]
        
        parent = Qt::Builder.current_layout
        parent.add_child(build(:layout, layout, &block))
        Qt::Builder.current_layout
      end
      
      def vbox(options = {}, &block)
        layout = Qt::VBoxLayout.new
        layout.margin = options[:margin] if options[:margin]
        
        parent = Qt::Builder.current_layout
        parent.add_child(build(:layout, layout, &block))
        Qt::Builder.current_layout
      end
    end
  end
end