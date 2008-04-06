module Qt
  module Dsl
    module Layouts
      def vbox(options = {}, &block)
        @layouts.unshift Qt::VBoxLayout.new
        instance_eval(&block) if block_given?
        @layouts[1].add_layout(@layouts.shift)
      end
    end
  end
end