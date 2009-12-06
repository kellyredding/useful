require File.dirname(__FILE__) + '/../test_helper'

class FixnumTest < Test::Unit::TestCase
  
  context "an extended Fixnum" do
    setup do
      @fixnum = 5
    end
    subject { @fixnum }
    
    should_have_instance_methods 'pad', 'to_nearest_value', 'to_time', 'ordinalize'
    
    should "pad to 3 wide with zeros by default" do
      assert_equal "005", subject.pad
    end

    should "pad to custom width with a custom char" do
      assert_equal "***5", subject.pad(4, '*')
      assert_equal "aba5", subject.pad(4, 'ab')
    end
    
    should "show itself ordinalized" do
      {
        1 => "1st",
        2 => "2nd",
        3 => "3rd",
        4 => "4th",
        110 => "110th",
        111 => "111th",
        112 => "112th",
        113 => "113th"
      }.each {|num, ord_str| assert_equal ord_str, num.ordinalize}
    end
  end
  
end