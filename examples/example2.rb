$:.unshift File.join(File.dirname(__FILE__), '../lib')
require 'qt'

Qt.app do
  window :main do
    options :title => "Calling It Quits", :size => [80, 40]
    
    push_button "Quit" do |b|
      b.font = Qt::Font.new("Times", 18, Qt::Font::Weight::Bold.value)
      b.pressed do # clicked doesn't work properly
        application.exit
      end
    end
  end
end