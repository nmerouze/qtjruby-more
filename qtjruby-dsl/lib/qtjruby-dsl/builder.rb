module Qt
  module JRuby
    module Builder
      
      mattr_accessor :windows, :layouts, :menus, :elements
      @@windows, @@layouts, @@menus = [], [], []
      
      class << self
        
        def create(name, options = {}, &block)
          @@elements ||= {}
          @@elements[name.to_sym] = block
          
          method("create_#{options[:type]}").call(name)
        end
        
        def create_widget(name)
          self.class_eval %{
            def self.#{name}(*args, &block)
              source = source('#{name}', *args)
              @@layouts.first.add_widget(source)
              
              render(source, &block)
            end
          }
        end
        
        def create_layout(name)
          self.class_eval %{
            def self.#{name}(*args, &block)
              source = source('#{name}', *args)
              @@layouts.first.add_layout(source) unless @@layouts.empty? # FIXME: Bug with multi-window applications
              @@layouts.unshift(source)

              render(source, &block)
              @@layouts.shift
            end
          }
        end
        
        def source(name, *args)
          @@elements[name.to_sym].call(args)
        end
        
        def render(source, &block)
          block.call(source) if block_given?
          return source
        end
        
      end
      
      # Widgets
      
      create :browser, :type => :widget do |args|
        Qt::WebView.new(*args)
      end
      
      create :button, :type => :widget do |args|
        case args.length
          when 1
            Qt::PushButton.new(args.first)
          when 2
            Qt::PushButton.new(Qt::Icon.new(args.last), args.first)
          else
            Qt::PushButton.new(*args)
        end
      end
      
      create :lcd_number, :type => :widget do |args|
        Qt::LCDNumber.new(*args)
      end
      
      create :line_edit, :type => :widget do |args|
        Qt::LineEdit.new(*args)
      end
      
      create :list_box, :type => :widget do |args|
        Qt::ListWidget.new(*args)
      end
      
      create :text_edit, :type => :widget do |args|
        Qt::TextEdit.new(*args)
      end
      
      create :video, :type => :widget do |args|
        Qt::VideoPlayer.new(Qt::Phonon::Category::VideoCategory)
      end
      
      def self.window(&block)
        @@windows.unshift(Qt::Widget.new)
        @@windows.first.layout = vbox(&block)
        
        return @@windows.shift
      end
      
      # Dialogs
      
      def self.alert(text = nil, title = nil)
        dialog = Qt::MessageBox.information(@@windows.first, title, text)
        yield if dialog == Qt::MessageBox::StandardButton::Ok && block_given?
      end
      
      def self.input_dialog(label = nil, title = 'Input Dialog')
        text = Qt::InputDialog.get_text(@@windows.first, title, label)
        yield text if !text.nil? && !text.empty? && block_given?
      end
      
      # Menus
      
      def self.action(*args, &block)
        source = Qt::Action.new(*args.push(@@windows.first))
        @@menus.first.add_action(source)

        render(source, &block)
      end
      
      def self.menu(*args, &block)
        source = Qt::Menu.new(*args)
        @@menus.first.add_menu(source)
        @@menus.unshift(source)

        render(source, &block)
        @@menus.shift
      end
      
      def self.menu_bar(*args, &block)
        @@menus.unshift(Qt::MenuBar.new(@@windows.first))
        render(@@menus.first, &block)
        @@menus.shift
      end
      
      # Layouts
      
      create :hbox, :type => :layout do |args|
        Qt::HBoxLayout.new(*args)
      end
      
      create :vbox, :type => :layout do |args|
        Qt::VBoxLayout.new(*args)
      end
      
    end
  end
end