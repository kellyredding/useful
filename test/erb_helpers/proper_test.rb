require File.dirname(__FILE__) + '/../test_helper'

class ProperTest < Test::Unit::TestCase
  
  include Useful::ErbHelpers::Proper

  context "the erb helper" do
    
    context "'proper_select_tag'" do
      setup do
        @name = 'user'
        @select_options = '<option>test</option>'
        @opts = { :tag => 'select' }
      end
      should "render with just a name" do
        @select_options = nil
        expected = input_tag(nil, @name, nil, @opts)
        erb_helper_clear_output_buffer
        result = proper_select_tag(@name)
        assert_equal expected, result
      end
      should "render with a name and select options" do
        expected = input_tag(nil, @name, nil, @opts) { @select_options }
        erb_helper_clear_output_buffer
        result = proper_select_tag(@name) { @select_options }
        assert_equal expected, result
      end
      context "using multiple selection" do
        setup do
          @opts[:multiple] = 'multiple'
        end
        should "render" do
          expected = input_tag(nil, @name+"[]", nil, @opts) { @select_options }
          erb_helper_clear_output_buffer
          result = proper_select_tag(@name, :multiple => true) { @select_options }
          assert_equal expected, result
        end
        should "render with nested name" do
          @name += "[name]"
          expected = input_tag(nil, @name+"[]", nil, @opts) { @select_options }
          erb_helper_clear_output_buffer
          result = proper_select_tag(@name, :multiple => true) { @select_options }
          assert_equal expected, result
        end
      end
    end

  end

end