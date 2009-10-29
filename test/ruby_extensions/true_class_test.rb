require File.dirname(__FILE__) + '/../test_helper'

class TrueClassTest < Test::Unit::TestCase
  
  context "an extended TrueClass" do
    setup do
      @true = true
    end
    subject { @true }
    
    should_have_instance_methods 'to_boolean', 'to_affirmative', 'to_casual_s', 'to_i'
    
    should "return an affirmative string" do
      assert_equal 'Yes', subject.to_affirmative
    end
    should "return an abbrviated affirmative string" do
      assert_equal 'Y', subject.to_affirmative(true)
    end
    should "should return one when sent to_i" do
      assert_equal 1, subject.to_i
    end
    should "should return true when sent to_boolean" do
      assert_equal true, subject.to_boolean
    end

  end
  
end