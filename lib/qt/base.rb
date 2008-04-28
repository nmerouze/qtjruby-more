module Qt
  class Base
    include Qt::Dsl::Layouts
    include Qt::Dsl::Objects
    include Qt::Dsl::Widgets
    
    def initialize(&block)
      @window = build :main_window, Qt::Widget.new do
        build :layout, Qt::VBoxLayout.new do
          instance_eval(&block) if block_given?
        end
      end
      
      Qt::Builder.root.run
    end
    
    attr_reader :window
    alias :w :window

    def options(options = {})
      window.layout.margin = options[:margin] if options[:margin]
      window.window_title = options[:title] if options[:title]
      
      if options[:size]
        if options[:fixed]
          window.fixed_size = Qt::Size.send :new, *options[:size]
        else
          window.resize(*options[:size])
        end
      end
    end
    
    def has(method_name, widget, options = {}, &b1)
      inst_var = "@#{method_name}"
      args = options[:args].is_a?(Array) ? options[:args] : []
      instance_variable_set(inst_var, [method(widget), args, b1]) unless instance_variable_defined?(inst_var)
    
      metaclass.class_eval %{
        def #{method_name}(&b2)
          if #{inst_var}.is_a? Array
            #{inst_var} = #{inst_var}[0].call(*#{inst_var}[1], &#{inst_var}[2])
            #{inst_var}.add_block(&b2) if block_given?
          end
          #{inst_var}
        end
      }
    end
    
    def build(type, object, &block)
      Qt::Builder.const_get(type.to_s.camelize).new(object, &block).source
    end
    
    protected

      def method_missing(sym, *args, &block)
        metaclass.class_eval %{
          def #{sym}(*args, &block)
            build :widget, Qt::#{sym.to_s.camelize}.new(*args), &block
          end
        }
      
        send(sym, *args, &block)
      end
  end
end