require 'qt/mapper/events'
require 'qt/mapper/objects'

require 'qt/mapper/ext/web_view'

module Qt
  extend Mapper::ClassMethods

  com.trolltech.qt.core.Qt.constants.each do |const_name|
    const_set(const_name, com.trolltech.qt.core.Qt.const_get(const_name))
  end
  
end