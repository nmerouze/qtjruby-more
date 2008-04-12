module Qt
  class Base
    include Qt::Dsl::Layouts
    include Qt::Dsl::Objects
    include Qt::Dsl::Widgets
    
    attr_accessor :window

    def initialize(widget, &block)
      @window = build(:widget, Qt::Widget.new)
      @window.layout = build(:layout, Qt::VBoxLayout.new)
      instance_eval(&block) if block_given?
      @window.run
    end

    def options(options = {})
      @window.layout.margin = options[:margin] if options[:margin]
      @window.window_title = options[:title] if options[:title]
      
      if options[:size]
        if options[:fixed]
          @window.fixed_size = Qt::Size.send :new, *options[:size]
        else
          @window.resize(*options[:size])
        end
      end
    end
    
    def has(method_name, widget, options = {}, &b1)
      inst_var = "@#{method_name}"
      args = options[:args].is_a?(Array) ? options[:args] : []
      instance_variable_set(inst_var, [method(widget), args, b1]) unless instance_variable_defined?(inst_var)
    
      metaclass.class_eval %{
        def #{method_name}(&b2)
          #{inst_var}[0].call(*#{inst_var}[1], &#{inst_var}[2])
          #{inst_var}.add_block(&b2) if block_given?
          #{inst_var}
        end
      }
    end
    
    def build(type, object, &block)
      case type
      when :widget
        Qt::Builder::Widget.new(object, &block)
      when :layout
        Qt::Builder::Layout.new(object, &block)
      end
    end
    
    protected
      
      def method_missing(sym, *args, &block)
        metaclass.class_eval %{
          def #{sym}(*args, &block)
            build(:widget, Qt::#{sym.to_s.camelize}.new(*args), &block)
          end
        }
      
        send(sym, *args, &block)
      end
    
  end
end