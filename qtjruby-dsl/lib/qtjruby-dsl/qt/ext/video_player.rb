module Qt
  module Ext
    module VideoPlayer
      
      def self.included(base)
        base.class_eval do
          def new_play(url)
            old_play(Qt::MediaSource.new(Qt::Url.new(url)))
          end

          alias_method :old_play, :play
          alias_method :play, :new_play
        end
      end
      
    end
  end
end