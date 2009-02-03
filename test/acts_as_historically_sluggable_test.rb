require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'schema')

class ActsAsHistoricallySluggableTest < Test::Unit::TestCase
  context "a blog post" do
    setup { @blog_post = BlogPost.new(:title => "(My) Awesome Post!!") }

    context "saved for the first time" do
      setup { @blog_post.save }
      
      should_change "Slug.count", :by => 1
      should_change "@blog_post.slugs.count", :by => 1
      should_change "@blog_post.slug", :from => "", :to => "(My) Awesome Post!!".slugify
      
      should "slugify the title" do
        assert_equal @blog_post.title.slugify, @blog_post.current_slug.identifier
      end
      
      context "then deleted" do
        setup { @blog_post.destroy }
        should_change "Slug.count", :by => -1
      end
      
      context "then saved again" do
        context "with the same title" do
          setup { @blog_post.save }
          should_not_change "Slug.count"
          should_not_change "@blog_post.slug"
        end
        
        context "with a new title" do
          setup { @blog_post.update_attributes! :title => "Woooooo, Yeah,    Boy!  " }
          should_change "Slug.count", :by => 1
          should_change "@blog_post.slugs.count", :from => 1, :to => 2
          should_change "@blog_post.slug", :from => "(My) Awesome Post!!".slugify, 
            :to => "Woooooo, Yeah,    Boy!  ".slugify
            
          context "then saved back with the original title" do
            should "be valid" do
              @blog_post.title = "(My) Awesome Post!!"
              assert @blog_post.valid?, @blog_post.errors.full_messages.to_sentence
            end
          end
        end
      end
    end
    
    context "with the same slug as another blog post" do
      setup { @existing_post = BlogPost.create!(:title => @blog_post.title) }
      
      should "not be valid" do
        @blog_post.valid?
        assert_match /generated from title/i, @blog_post.errors.on(:current_slug)
      end
    end
    
    context "with a slug that's an historical slug from another blog post" do
      should "be valid" do
        @existing_post = BlogPost.create!(:title => "First Title")
        @existing_post.update_attributes!(:title => "Some New Title")
        
        @blog_post.title = "First Title"
        assert @blog_post.valid?, @blog_post.errors.full_messages.to_sentence
      end
    end
    
    teardown { Slug.delete_all } # no transactionality here, folks
  end
end