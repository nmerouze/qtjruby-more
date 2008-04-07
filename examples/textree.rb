require 'qt'

class Note
  attr_accessor :name
  attr_accessor :text
  
  def initialize(name, text = '')
    @name = name
    @text = text
  end
end

Qt.app do
  window :main do
    options :title => "Textree", :size => [640, 480]
    
    @notes = [Note.new('Foo')]
    @current_note = nil

    def create_note
      input_dialog "Name:" do |name|
        @notes << Note.new(name)
        @current_note = @notes.last
        note_list.add_item @current_note.name
      end
    end
    
    def save_note(note = @current_note)
      note.text = note_text.to_plain_text unless note.nil?
    end
    
    def change_item(previous, current)
      return if current.nil?
      
      save_note(@notes.select { |n| n.name == previous.text }.first)
      @current_note = @notes.select { |n| n.name == current.text }.first
      note_text.text = @current_note.text
    end

    has :new_action, :action do |a|
      a.text = '&New'
      a.shortcut = 'Ctrl+N'
      a.status_tip = 'Create a new note'
      a.triggered { create_note }
    end
    
    has :save_action, :action do |a|
      a.text = '&Save'
      a.shortcut = 'Ctrl+S'
      a.status_tip = 'Save note'
      a.triggered { save_note }
    end
    
    has :note_list, :list_box do |l|
      l.maximum_width = 200
      l.add_items @notes.collect { |n| n.name }
      l.current_item_changed { |p, c| change_item(p, c) }
      l.item_selection_changed  do
        note_text.enabled = true unless l.current_item.nil?
      end
    end
    
    has :note_text, :text_edit do |t|
      t.minimum_width = 400
      t.disabled = true
    end

    menu_bar do
      menu '&File' do
        new_action
        save_action
      end
    end
    
    hbox do
      note_list
      note_text
    end
  
  end
end