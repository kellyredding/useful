require File.dirname(__FILE__) + '/../test_helper'

class NilClassTest < Test::Unit::TestCase
  
  context "an extended NilClass" do
    setup do
      @nil = nil
    end
    subject { @nil }
    
    should_have_instance_methods 'try'    
    should "return nil when trying anything" do
      assert_equal nil, @nil.try
      assert_equal nil, @nil.try(:find, 1)
      assert_equal nil, @nil.try { "do something fancy here" }      
    end

    should_have_instance_methods 'to_boolean'    
    should "return false always when converting to boolean" do
      assert_equal false, @nil.to_boolean
    end

  end
  
end