require 'java'
require 'qtjruby-core.jar'
require 'qtjruby-core/core_ext'
require 'qtjruby-core/qt'

module Qt
  module JRuby
    
    @@root = nil
    
    class << self
      
      def root
        @@root ||= Dir.pwd
      end
      
    end
    
  end
end