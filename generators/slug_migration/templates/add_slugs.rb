class AddSlugs < ActiveRecord::Migration
  def self.up
    create_table :slugs do |table|
      table.string :identifier, :sluggable_type, :null => false
      table.integer :sluggable_id, :null => false
      table.timestamps
    end
    add_index :slugs, [:identifier, :sluggable_type], :unique => true
  end

  def self.down
    drop_table :slugs
  end
end