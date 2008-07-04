require 'qtjruby-dsl'
require 'active_record'
require 'hpricot'
require 'open-uri'
 
module Atom
  class Feed
    def initialize(uri)
      @feed = ::Hpricot.XML(open(uri))
    end
  
    def entries
      (@feed/:entry).collect { |entry| Atom::Entry.new(entry) }
    end
  
    def title
      @feed.at("title").inner_html
    end
  end
 
  class Entry
    def initialize(entry)
      @entry = entry
    end
  
    def author
      @entry.at("author").at("name").inner_html
    end
    
    ['id', 'title', 'content', 'published', 'updated'].each do |meth|
      define_method meth do
        @entry.at(meth).inner_html
      end
    end
    
    def to_hash
      { :entry_id => id, :author => author, :title => title, :content => content, :created_at => published, :updated_at => updated }
    end
  end
end
 
ActiveRecord::Base.establish_connection(
  :adapter => "jdbcderby",
  :database => "db/atom_reader"
)
 
class Feed < ActiveRecord::Base
  has_many :items
end
 
class Item < ActiveRecord::Base
  belongs_to :feed
end
 
unless Feed.table_exists?
  ActiveRecord::Base.connection.create_table(:feeds) do |t|
    t.string :name
    t.text :url
    t.datetime :created_at
  end
  
  ActiveRecord::Base.connection.create_table(:items) do |t|
    t.integer :entry_id, :feed_id
    t.string :title, :author
    t.text :content
    t.timestamps
  end
end
 
 
Qt.app do
  window :id => :main do
    @current_feed = nil
 
    def create_feed
      input_dialog "Url:" do |url|
        feed = Atom::Feed.new(url)
        
        @current_feed = Feed.create(:name => feed.title, :url => url)
        feed_list.add_item(@current_feed.name)
        
        feed.entries.each do |e|
          @current_feed.items.create(e.to_hash)
        end
      end
    end
    
    def change_feed(current, previous)
      return if current.nil?
 
      @current_feed = Feed.find_by_name(current.text)
      item_list.clear
      item_list.add_items @current_feed.items.collect { |i| i.title }
    end
    
    def select_item(current, previous)
      return if current.nil?
      
      item_text.html = @current_feed.items.find_by_title(current.text).content
    end
    
    create :feed_list, :type => :list_box do |fl|
      fl.maximum_width = 200
      fl.add_items Feed.find(:all, :order => 'name ASC').collect { |n| n.name }
      fl.current_item_changed { |c, p| change_feed(c, p) }
    end
    
    create :item_list, :type => :list_box do |il|
      il.current_item_changed { |c, p| select_item(c, p) }
    end
    
    create :item_text, :type => :text_edit
    
    create :new_action, :type => :action do |a|
      a.text = '&New'
      a.shortcut = 'Ctrl+N'
      a.status_tip = 'Create a new feed'
      a.triggered { create_feed }
    end
    
    # options :title => 'Atom Reader', :size => [800, 600]
    
    menu_bar do
      menu '&File' do
        new_action 
      end
    end
    
    hbox do
      feed_list
      
      vbox do
        item_list
        item_text
      end
    end
  end
end