module Qt
  module Ext
    module WebView
      
      def self.included(base)
        base.class_eval do
          def new_load(url)
            old_load(Qt::Url.new(url))
          end

          alias_method :old_load, :load
          alias_method :load, :new_load
        end
      end
      
    end
  end
end