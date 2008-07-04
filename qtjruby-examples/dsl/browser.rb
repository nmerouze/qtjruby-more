require 'qtjruby-dsl'

Qt.app do
  window :id => 'main' do
    create :bsr_main, :type => :browser
    create :le_address, :type => :line_edit

    hbox do
      le_address
      button('Go').clicked do
        bsr_main.load le_address.text
      end
    end

    bsr_main.load 'http://github.com'
  end
end