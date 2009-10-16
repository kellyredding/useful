require File.dirname(__FILE__) + '/../test_helper'

class ArrayTest < Test::Unit::TestCase
  
  context "an extended array" do
    setup do
      @array = Array.new
      
      @a1 = [1,2,3]
      @a2 = ['a','b','c']
      @a1a2 = [1,2,3,'a','b','c']

      @g0 = [ ]
      @g1 = [ [1], [2], [3], ['a'], ['b'], ['c'] ]
      @g2 = [ [1,2], [3,'a'], ['b','c'] ]
      @g3 = [ [1,2,3], ['a','b','c'] ]
      @g4 = [ [1,2,3,'a'], ['b','c'] ]
      @g5 = [ [1,2,3,'a','b'], ['c'] ]
      @g6 = [ [1,2,3,'a','b','c'] ]
      @g7 = [ [1,2,3,'a','b','c'] ]
    end
    subject { @array }
    
    should_have_class_methods 'merge'
    should_have_instance_methods 'merge', 'merge!', 'groups', '/', 'chunks'
    
    should "merge at the class level" do
      assert_equal @a1a2, Array.merge(@a1, @a2)
    end
    should "merge at the instance level" do
      assert_equal @a1a2, @a1.merge(@a2)
    end
    should "destructively merge at the instance level" do
      @a1.merge!(@a2)
      assert_equal @a1a2, @a1
    end

    should "group itself in various sizes" do
      0.upto(7) do |num|
        assert_equal instance_variable_get("@g#{num}"), @a1a2.groups(num)
      end
    end
  end
  
end