module Qt
  module Dsl
    module Layouts
      def hbox(options = {}, &block)
        @layouts.unshift Qt::HBoxLayout.new
        instance_eval(&block) if block_given?
        @layouts[1].add_layout(@layouts.shift)
      end
    end
  end
end