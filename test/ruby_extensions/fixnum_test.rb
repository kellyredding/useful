require File.dirname(__FILE__) + '/../test_helper'

class FixnumTest < Test::Unit::TestCase
  
  context "an extended Fixnum" do
    setup do
      @fixnum = 5
    end
    subject { @fixnum }
    
    should_have_instance_methods 'pad', 'to_nearest_value'
    
    should "pad to 3 wide with zeros by default" do
      assert_equal "005", subject.pad
    end

    should "pad to custom width with a custom char" do
      assert_equal "***5", subject.pad(4, '*')
      assert_equal "aba5", subject.pad(4, 'ab')
    end
  end
  
end