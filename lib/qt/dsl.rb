module Qt

  @@windows = {}

  class << self
    
    def app(&block)
      Qt.module_eval(&block) if block_given?
      open :main unless @@windows[:main].nil?
      Qt::Application.exec
    end

    def window(sym, &block)
      Qt::Application.new(ARGV.to_java(:string)) unless Qt::Application.instance
      @@windows[sym] = Base.new(&block)
    end
    
    def open(sym)
      @@windows[sym].window.show
    end
    
    def hide(sym)
      @@windows[sym].window.hide
    end
    
    def close(sym)
      @@windows[sym].window.close
    end
    
  end

  class Base
    
    attr_accessor :window
  
    def initialize(&block)
      @layouts = [Qt::VBoxLayout.new]
      
      @window = Qt::Widget.new
      @window.set_layout(@layouts.first)
    
      instance_eval(&block) if block_given?
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
  
    def application
      Qt::Application
    end

    def vbox(options = {}, &block)
      @layouts.unshift Qt::VBoxLayout.new
      instance_eval(&block) if block_given?
      @layouts[1].add_layout(@layouts.shift)
    end

    def hbox(options = {}, &block)
      @layouts.unshift Qt::HBoxLayout.new
      instance_eval(&block) if block_given?
      @layouts[1].add_layout(@layouts.shift)
    end
    
    def information_dialog(text, title = 'Information')
      Qt::MessageBox.information(@window, title, text)
    end
    
    def tr(text)
      @window.tr(text)
    end
    
    def lcd_number(*args, &block)
      widget = Qt::LCDNumber.send :new, *args
      @layouts.first.add_widget(widget)
      block.call(widget) if block_given?
      return widget
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