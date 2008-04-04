# http://doc.trolltech.com/qtjambi-4.4.0_01/doc/html/com/trolltech/qt/qtjambi-signalsandslots.html
$:.unshift File.join(File.dirname(__FILE__), '../lib')
require 'qt'

class Counter
  attr_reader :value, :value_changed
  
  def initialize
    @value_changed = Qt.signal(1)
    @value = 0
  end
  
  def value=(value)
    if @value != value
      @value = value
      @value_changed.emit(value)
    end
  end
end

a = Counter.new
b = Counter.new

Qt.connect(a.value_changed, b.method('value='))
a.value = 12
puts "#{a.value}, #{b.value}"
b.value = 48
puts "#{a.value}, #{b.value}"