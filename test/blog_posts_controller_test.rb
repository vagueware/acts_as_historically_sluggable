require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'schema')
require File.join(File.dirname(__FILE__), 'routes')

class BlogPostsController < ActionController::Base
  find_object_by_slug :blog_post, :only => [:show]
  
  def show
    render :text => "succeeded in showing: #{@blog_post.id}"
  end
end

class BlogPostsControllerTest < ActionController::TestCase
  tests BlogPostsController
  
  def setup
    @blog_post = BlogPost.create(:title => "First Post")
    @blog_post.update_attributes!(:title => "Revised Title")
  end
  
  context "getting the current slug" do
    setup { get :show, :id => 'revised_title' }
    should_assign_to :blog_post
    should_respond_with :success
    should "find the correct blog post" do
      assert_match(/: #{@blog_post.id}/, @response.body)
    end
  end
  
  context "getting the previous slug" do
    setup { get :show, :id => 'first_post' }
    should_not_assign_to :blog_post
    should_respond_with :moved_permanently
    should_redirect_to "blog_post_path(:id => 'revised_title')"
  end
  
  context "getting a non-existent slug" do
    should "raise an AR::NotFound error" do
      assert_raises ActiveRecord::RecordNotFound do
        get :show, :id => 'gshjkhksajgsjghk'
      end
    end
  end
  
  def teardown
    Slug.delete_all
  end
end