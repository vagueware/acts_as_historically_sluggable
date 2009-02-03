ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => 'aahs_test.db')
RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)

ActiveRecord::Schema.define(:version => 1) do
  create_table :blog_posts, :force => true do |table|
    table.string :title
  end
  
  create_table :slugs, :force => true do |table|
    table.string :identifier, :sluggable_type, :null => false
    table.integer :sluggable_id, :null => false
    table.timestamps
  end
end

class BlogPost < ActiveRecord::Base
  acts_as_historically_sluggable :title
end