# jruby -S gem install -y activerecord-jdbcderby-adapter
require 'qt'

require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "jdbcderby",
  :database => "db/textree"
)

class Note < ActiveRecord::Base
  validates_uniqueness_of :name
end

unless Note.table_exists?
  ActiveRecord::Base.connection.create_table(:notes) do |t|
    t.string :name
    t.text :text
    t.datetime :created_at
  end
end

Qt.app do
  window :main do
    @current_note = nil

    def create_note
      input_dialog "Name:" do |name|
        @current_note = Note.create(:name => name, :text => '')
        note_list.add_item @current_note.name
      end
    end
    
    def save_note(note = @current_note)
      note.update_attributes(:text => note_text.to_plain_text) unless note.nil?
    end
    
    def change_item(current, previous)
      return if current.nil?
      
      save_note(Note.find_by_name(previous.text)) unless previous.nil?
      @current_note = Note.find_by_name(current.text)
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
      l.add_items Note.find(:all, :order => 'name ASC').collect { |n| n.name }
      l.current_item_changed { |c, p| change_item(c, p) }
      l.item_selection_changed  do
        note_text.enabled = true unless l.current_item.nil?
      end
    end
    
    has :note_text, :text_edit do |t|
      t.minimum_width = 400
      t.disabled = true if @current_note.nil?
    end
    
    options :title => "Textree", :size => [640, 480]

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