require 'qt'

Qt.app do
  window :main do
    options :title => "Building Blocks"
    
    has :lcd, :lcd_number do |l|
      l.segment_style = Qt::LCDNumber::SegmentStyle::Filled
    end
    
    vbox do
      
      push_button "Quit" do |b|
        b.font = Qt::Font.new("Times", 18, Qt::Font::Weight::Bold.value)
        b.pressed do # clicked doesn't work properly
          application.exit
        end
      end
      
      lcd(2)
      
      slider(Qt::Orientation::Horizontal) do |s|
        s.set_range 0, 99
        s.value = 0
        # value_changed doesn't work properly
      end
      
    end
    
  end
end