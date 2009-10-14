require File.dirname(__FILE__) + '/../test_helper'
require 'useful/ruby_extensions'

class FalseClassTest < Test::Unit::TestCase
  
  context "an extended FalseClass" do
    setup do
      @false = false
    end
    subject { @false }
    
    should_have_instance_methods 'to_boolean', 'to_affirmative', 'to_casual_s', 'to_i'
    
    should "return an affirmative string" do
      assert_equal 'No', subject.to_affirmative
    end
    should "return an abbrviated affirmative string" do
      assert_equal 'N', subject.to_affirmative(true)
    end
    should "should return zero when sent to_i" do
      assert_equal 0, subject.to_i
    end
    should "should return false when sent to_boolean" do
      assert_equal false, subject.to_boolean
    end

  end
  
end