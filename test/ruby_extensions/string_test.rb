require File.dirname(__FILE__) + '/../test_helper'
require 'useful/ruby_extensions'

class StringTest < Test::Unit::TestCase
  
  context "an extended String" do
    
    context "with a hash of key-values" do
      setup do
        @key_values = {:a => 'aye', :b => 'bee', :c => 'see'}
        @key_string = "Now I know my :a-:b-:c's..."
        @value_string = "Now I know my aye-bee-see's..."
      end

      should_have_class_methods 'hsub'
      should_have_instance_methods 'hsub', 'hsub!'
      should "support hash based substitution at the class level" do
        assert_equal @value_string, String.hsub(@key_string, @key_values)
      end
      should "support hash based substitution at the instance level" do
        assert_equal @value_string, @key_string.hsub(@key_values)
      end
      should "support destructive hash based substitution at the instance level" do
        @key_string.hsub!(@key_values)
        assert_equal @value_string, @key_string
      end
    end
    
    context "with a regular expression" do
      setup do
        @string_parts = ["the ", "kelredd", "-useful gem is awesome"]
        @match_re = /kelredd/
        @no_match_re = /sucks/
      end
      
      should_have_class_methods 'match?', 'show_regexp'
      should_have_instance_methods 'match?', 'show_regexp'
      should "answer match question at class level" do
        assert String.match?(@string_parts.join, @match_re)
        assert !String.match?(@string_parts.join, @no_match_re)
      end
      should "answer match question at instance level" do
        assert @string_parts.join.match?(@match_re)
        assert !@string_parts.join.match?(@no_match_re)
      end
      should "show the regular expression at class level" do
        assert_equal @string_parts[0]+'<<'+@string_parts[1]+'>>'+@string_parts[2], String.show_regexp(@string_parts.join, @match_re)
        assert_equal "no match", String.show_regexp(@string_parts.join, @no_match_re)
      end
      should "show the regular expression at the instance level" do 
        assert_equal @string_parts[0]+'<<'+@string_parts[1]+'>>'+@string_parts[2], @string_parts.join.show_regexp(@match_re)
        assert_equal "no match", @string_parts.join.show_regexp(@no_match_re)
      end      
    end
    
    should_have_instance_methods 'to_boolean'
    should "be convertable to boolean" do 
      assert !"0".to_boolean
      assert !"false".to_boolean
      assert "1".to_boolean
      assert "true".to_boolean
      assert !"2".to_boolean
      assert !"poo".to_boolean
    end

  end
  
end