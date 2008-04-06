module Qt
  module Dsl
    module Application
      module Window
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
      end
    end
  end
end