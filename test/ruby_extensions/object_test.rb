require File.dirname(__FILE__) + '/../test_helper'

class ObjectTest < Test::Unit::TestCase
  
  context "an extended Object" do
    setup do
      @obj = Object.new
      @true = true
      @false = false
    end
    subject { @obj }
    
    should_have_instance_methods 'false?', 'is_false?', 'true?', 'is_true?'
    
    should "know if its true" do
      assert @true.true?
      assert @true.is_true?
      assert !@false.true?
      assert !@false.is_true?
    end
    should "know if its false" do
      assert !@true.false?
      assert !@true.is_false?
      assert @false.false?
      assert @false.is_false?
    end

    should_have_instance_methods 'capture_std_output'    
    should "capture $stdout" do
      out, err = capture_std_output do
        p "some output"
      end
      assert_kind_of ::StringIO, out
      assert_kind_of ::StringIO, err
      assert err.string.empty?
      assert_equal "\"some output\"\n", out.string
    end
    should "capture $stderr" do
      out, err = capture_std_output do
        $stderr.write "an error"
      end
      assert out.string.empty?
      assert_equal "an error", err.string
    end
    should "capture both $stdout and $stderr at the same time" do
      out, err = capture_std_output do
        p "some more output"
        $stderr.write "an error"
      end
      assert_equal "\"some more output\"\n", out.string
      assert_equal "an error", err.string
    end

    should_have_instance_methods 'blank?', 'returning', 'tap', 'try'
    
    should "know if it is blank" do
      [nil, false,"",[],{}].each do |obj|
        assert obj.blank?
      end
      [true, "poo", [1], {:one => 1}].each do |obj|
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
    
    should "try method calls with nil safety" do
      obj = [1,2,3]
      nested_obj = [['a','b','c'], 1, 2, 3, nil]
      assert_equal obj.first, obj.try(:first)
      assert_equal nested_obj.first.first, nested_obj.try(:first).try(:first)
      assert_equal nil, nested_obj.try(:last).try(:first)
    end
    


  end
  
end