$:.unshift File.join(File.dirname(__FILE__), '../lib')
require 'qt'

Qt.app do
  window :main do
    options :title => "Hello World", :size => [120, 40]
    
    push_button "Hello World!"
  end
end