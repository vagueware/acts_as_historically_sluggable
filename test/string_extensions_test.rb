require File.join(File.dirname(__FILE__), 'test_helper')

class StringExtensionsTest < Test::Unit::TestCase
  context "slugify" do
    should "downcase strings" do
      assert_equal "hello", "HeLLo".slugify
    end
    
    should "strip strings" do
      assert_equal "hello", "    hello    ".slugify
    end
    
    should "replace spaces with underscores" do
      assert_equal "hello_there", "hello there".slugify
    end
    
    should "squeeze spaces" do
      assert_equal "hello_there", "hello    there".slugify
    end
    
    should "remove anything that's not a letter, number, or underscore" do
      assert_equal "hello", 'hello~!@#$%^&*()'.slugify
    end
  end
end