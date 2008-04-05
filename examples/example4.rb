require 'qt'

Qt.app do
  window :main do
    options :title => "Let There Be Widgets", :size => [200, 120], :fixed => true
    
    push_button "Quit" do |b|
      b.font = Qt::Font.new("Times", 18, Qt::Font::Weight::Bold.value)
      b.set_geometry(62, 40, 75, 30)
      b.pressed do # clicked doesn't work properly
        application.exit
      end
    end
  end
end