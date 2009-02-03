class Slug < ActiveRecord::Base
  belongs_to :sluggable, :polymorphic => true
  
  validates_presence_of :identifier
  validates_uniqueness_of :identifier, :scope => :sluggable_type
  
  def historical?
    sluggable.current_slug != self
  end
end