require File.dirname(__FILE__) + '/../test_helper'

class ObjectTest < Test::Unit::TestCase
  
  context "an extended Object" do
    setup do
      @obj = Object.new
      @true = true
      @false = false
    end
    subject { @obj }
    
    should_have_instance_methods 'false?', 'true?'
    
    should "know if its true" do
      assert @true.true?
      assert !@false.true?
    end
    should "know if its false" do
      assert !@true.false?
      assert @false.false?
    end

    should_have_instance_methods 'blank?', 'returning', 'tap'
    
    should "know if it is blank" do
      [nil,"",[],{}].each do |obj|
        assert obj.blank?
      end
      [false, true, "poo", [1], {:one => 1}].each do |obj|
        assert !obj.blank?
      end
    end
    
    should "handle returning with a local variable" do
      returning values = [] do
        values << 1
        values << 2
      end
      assert_equal [1,2], values
    end
    
    should "handle returning with a block argument" do
      val = returning [] do |values|
        values << 1
        values << 2
      end
      assert_equal [1,2], val
    end

    should "handle tapping into method chains" do
      tapped_values = []
      (1..10).
        tap{|v| tapped_values << v}.
        select{|num| num % 2 == 0 }.
        tap{|v|  tapped_values << v}.
        to_s
      assert_equal [1..10, [2,4,6,8,10]], tapped_values
    end

  end
  
end