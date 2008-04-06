module Qt
  module Mapper
    module ClassMethods
      
      def class_name(name)
        ['.gui', '.core', '.webkit', '', '.phonon', '.svg', '.opengl'].each do |path|
          begin
            return Java::JavaClass.for_name("com.trolltech.qt#{path}.Q#{name}").name
          rescue
            next
          end
        end
      end

      def const_missing(name)
        klass = Class.new(Java::JavaClass.for_name(Qt.class_name(name)).ruby_class)

        klass.class_eval do
          @@class_name = Qt.class_name(name)
          include Qt::Mapper::Ext.const_get(name) if Qt::Mapper::Ext.const_defined?(name)

          def initialize(*args)
            super(*args)

            @source = self.clone

            Java::JavaClass.for_name(@@class_name).fields.each do |field|
              if field.type.to_s =~ /QSignalEmitter/
                (class << self; self; end).class_eval %Q{
                  def #{field.name}(*args, &block)
                    Qt.connect(@source.#{field.name}, self.method('slot'), &block)
                  end
                  alias :#{field.name.underscore} :#{field.name}
                }
              end
            end
          end

          protected

            def slot(*args, &block)
              block.call(*args) if block_given?
            end
        end

        return const_set(name, klass)
      end
      
    end
  end
end