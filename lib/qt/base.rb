module Qt
  class Base
    include Qt::Dsl::Layouts
    include Qt::Dsl::Objects
    include Qt::Dsl::Widgets
    
    attr_accessor :window

    def initialize(widget, &block)
      @window = Qt::Widget.new
      @window.layout = add_layout Qt::VBoxLayout.new
      
      instance_eval(&block) if block_given?
    end

    def options(options = {})
      @window.layout.margin = options[:margin] ? options[:margin] : 0
      @window.window_title = options[:title] if options[:title]
      
      if options[:size]
        if options[:fixed]
          @window.fixed_size = Qt::Size.send :new, *options[:size]
        else
          @window.send :resize, *options[:size]
        end
      end
      
      # TODO: Put the default layout in the options
    end
    
    def has(method, widget, &block)
      (class << self; self; end).class_eval do
        define_method method do |*args|
          unless instance_variable_defined?("@#{method}")
            instance_variable_set("@#{method}", send(widget, *args, &block))
          end

          instance_variable_get("@#{method}")
        end
      end
    end
  
    def method_missing(sym, *args, &block)
      (class << self; self; end).class_eval %{
        def #{sym}(*args, &block)
          add_widget Qt::#{sym.to_s.camelize}.new(*args), &block
        end
      }
      
      send(sym, *args, &block)
    end
    
    protected
    
      def add_widget(widget)
        @layouts.first.add_widget(widget)
        yield widget if block_given?
        widget
      end
      
      def add_layout(layout)
        @layouts = [] if @layouts.nil?
        @layouts.unshift layout
        yield if block_given?
        return layout if @layouts.length == 1
        
        @layouts[1].add_layout(@layouts.shift)
      end
    
  end
end