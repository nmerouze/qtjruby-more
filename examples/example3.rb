$:.unshift File.join(File.dirname(__FILE__), '../lib')
require 'qt'

Qt.app do
  window :main do
    options :title => "FamilyValues", :size => [200, 120]
    
    push_button "Quit" do |b|
      b.font = Qt::Font.new("Times", 18, Qt::Font::Weight::Bold.value)
      b.set_geometry(10, 40, 180, 40)
      b.pressed do # clicked doesn't work properly
        application.exit
      end
    end
  end
end