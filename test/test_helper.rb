require 'rubygems'
require 'activerecord'
require 'action_controller'
require 'shoulda'
require 'shoulda/controller'
require 'ruby-debug'

require 'test/unit'
require 'action_controller/test_process'

require File.join(File.dirname(__FILE__), '..', 'init')

Test::Unit::TestCase.class_eval do
  def deny(expression, message=nil)
    assert !expression, message
  end
end

def log_to(stream)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
end