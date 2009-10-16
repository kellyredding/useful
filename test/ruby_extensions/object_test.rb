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

  end
  
end