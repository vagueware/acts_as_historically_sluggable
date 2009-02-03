require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'schema')

class SlugTest < Test::Unit::TestCase
  # should_require_attributes :identifier
  # should_require_unique_attributes :identifier, :scope => :sluggable_type
  
  context "historical?" do
    setup do 
      @blog_post = BlogPost.create!(:title => "Oh yeah")
      @blog_post.update_attributes!(:title => "No ways")
      @blog_post.update_attributes!(:title => "Whoa, for reals?")
    end
    
    should "be false for the current_slug" do
      deny @blog_post.current_slug.historical?
    end
    
    should "be true for all other slugs" do
      @blog_post.slugs.reject {|slug| slug == @blog_post.current_slug }.each do |slug|
        assert slug.historical?
      end
    end
    
    teardown { Slug.delete_all }
  end
end