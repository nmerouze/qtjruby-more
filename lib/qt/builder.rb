require 'qt/builder/layout'
require 'qt/builder/main_window'
require 'qt/builder/menu'
require 'qt/builder/menu_bar'
require 'qt/builder/widget'

module Qt
  module Builder
    mattr_accessor :root, :layouts, :menus
    
    @@layouts = []
    
    def self.layout
      @@layouts.last
    end
    
    @@menus = []
    
    def self.menu
      @@menus.last
    end
  end
end