module Qt
  class Base
    include Qt::Dsl::Application::Window
    include Qt::Dsl::Objects
    include Qt::Dsl::Widgets
    
    attr_accessor :window
  
    def initialize(&block)
      @layouts = [Qt::VBoxLayout.new]
      
      @window = Qt::Widget.new
      @window.set_layout(@layouts.first)
    
      instance_eval(&block) if block_given?
    end

    def options(options = {})
      @window.layout.margin = options[:margin] if options[:margin]
      @window.window_title = options[:title] if options[:title]
      
      if options[:size]
        if options[:fixed]
          @window.fixed_size = Qt::Size.send :new, *options[:size]
        else
          @window.send :resize, *options[:size]
        end
      end
    end
  
    def method_missing(sym, *args, &block)
      (class << self; self; end).class_eval do
        define_method sym do |*args|
          widget = Qt.const_get(sym.to_s.camelize).send :new, *args
          @layouts.first.add_widget(widget)
          block.call(widget) if block_given?
          return widget
        end
      end
      
      send(sym, *args, &block)
    end
    
  end
end