module Qt
  module Dsl
    module Application
      module Qt
        
        @@windows = {}

        def app(&block)
          module_eval(&block) if block_given?
          open :main unless @@windows[:main].nil?
          ::Qt::Application.exec
        end

        def window(sym, &block)
          ::Qt::Application.new(ARGV.to_java(:string)) unless ::Qt::Application.instance
          @@windows[sym] = ::Qt::Base.new(&block).window
        end

        def open(sym)
          @@windows[sym].show
        end

        def hide(sym)
          @@windows[sym].hide
        end

        def close(sym)
          @@windows[sym].close
        end
      
      end
    end
  end
end