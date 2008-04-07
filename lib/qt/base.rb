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
    
      # TODO: Convert these methods to a generic tree Builder
    
      def add_widget(widget)
        @layouts.first.add_widget(widget)
        yield widget if block_given?
        widget
      end
      
      def add_layout(layout)
        @layouts = [] if @layouts.nil?
        @layouts.unshift layout
        yield layout if block_given?
        return layout if @layouts.length == 1
        
        @layouts[1].add_layout(@layouts.shift)
      end
      
      def add_menu(menu)
        @menus = [] if @menus.nil?
        @menus.unshift menu
        yield menu if block_given?
        return menu if @menus.length == 1
        
        if menu.is_a? Qt::Menu
          @menus[1].add_menu(@menus.shift)
        elsif menu.is_a? Qt::Action
          @menus[1].add_action(@menus.shift)
        end
      end
    
  end
end