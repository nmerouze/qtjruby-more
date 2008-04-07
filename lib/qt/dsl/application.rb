module Qt
  module Dsl
    module Application
      
      @@windows = {}

      def app(&block)
        module_eval(&block) if block_given?
        open :main unless @@windows[:main].nil?
        Qt::Application.exec
      end

      def window(sym, widget = Qt::Widget, &block)
        Qt::Application.new(ARGV.to_java(:string)) unless Qt::Application.instance
        @@windows[sym] = Qt::Base.new(widget, &block).window
      end
      
      # def main_window(sym, &block)
      #   Qt.window(sym, Qt::MainWindow, &block)
      # end

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