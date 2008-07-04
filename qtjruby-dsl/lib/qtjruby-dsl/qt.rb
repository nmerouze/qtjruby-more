extlib = File.join(File.dirname(__FILE__), 'qt', 'ext')

require extlib / :video_player
require extlib / :web_view

module Qt
  class << self
    
    def app(&block)
      Qt::Application.initialize(ARGV)
      instance_eval(&block)
      show :main
      Qt::Application.exec
    end
    
    def window(options = {}, &block)
      @windows ||= {}
      @windows[options[:id].to_sym] ||= Qt::JRuby::Builder.window(&block)
    end
    
    [:show, :hide, :close].each do |meth_name|
      class_eval %{
        def #{meth_name}(id)
          @windows[id.to_sym].#{meth_name} unless @windows[id.to_sym].nil?
        end
      }
    end
    
    def create(name, options = {}, &block)
      @widgets ||= {}
      @widgets[name.to_sym] = options.merge(:block => block)
      
      self.class_eval %{
        def self.#{name}(*args, &block)
          return @@#{name} if class_variable_defined?(:@@#{name})
          widget = @widgets['#{name}'.to_sym]
          if args.empty?
            args = widget[:args].nil? ? [] : widget[:args]
          end
          
          @@#{name} = method_missing(widget[:type], *args, &widget[:block])
          block.call(@@#{name}) if block_given?
          return @@#{name}
        end
      }
    end
    
    def method_missing(name, *args, &block)
      self.class_eval %{
        def self.#{name}(*args, &block)
          Qt::JRuby::Builder.method('#{name}').call(*args, &block)
        end
      }
    
      __send__ name, *args, &block
    end
      
  end
end