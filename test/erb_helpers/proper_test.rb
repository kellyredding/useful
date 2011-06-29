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

    context "'proper_check_box_tag'" do
      setup do
        @name = "complete"
        @value = '1'
        @opts = {
          :id => 'complete'
        }
      end
      should "render standalone check box" do
        expected = input_tag(:checkbox, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_check_box_tag(@name, :disable_unchecked_value => true)
        assert_equal expected, result
      end
      should "render standalone check box with nested name" do
        @name = "user[complete]"
        @opts[:id] = "user_complete"
        expected = input_tag(:checkbox, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_check_box_tag(@name, :disable_unchecked_value => true)
        assert_equal expected, result
      end
      should "render standalone check box checked" do
        @opts[:checked] = Useful::ErbHelpers::Common::OPTIONS[:checked]
        expected = input_tag(:checkbox, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_check_box_tag(@name, :checked => true, :disable_unchecked_value => true)
        assert_equal expected, result
      end
      should "render labeled check box" do
        label_text = 'complete ?'
        expected = tag(:label, :for => @opts[:id]) do
          input_tag(:checkbox, @name, @value, @opts) + label_text
        end
        erb_helper_clear_output_buffer
        result = proper_check_box_tag(@name, :label => label_text, :disable_unchecked_value => true)
        assert_equal expected, result
      end
      should "render standalone check box with an unchecked default value" do
        expected = input_tag(:hidden, @name, '0', :id => "#{@opts[:id]}_hidden")
        expected << input_tag(:checkbox, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_check_box_tag(@name)
        assert_equal expected, result
      end
      should "render labeled check box with an unchecked default value" do
        label_text = 'complete ?'
        expected = input_tag(:hidden, @name, '0', :id => "#{@opts[:id]}_hidden")
        expected << tag(:label, :for => @opts[:id]) do
          input_tag(:checkbox, @name, @value, @opts) + label_text
        end
        erb_helper_clear_output_buffer
        result = proper_check_box_tag(@name, :label => label_text)
        assert_equal expected, result
      end
    end

    context "'proper_radio_button_tag'" do
      setup do
        @name = "level"
        @value = '1'
        @opts = {
          :id => 'level'
        }
      end
      should "render standalone radio button" do
        expected = input_tag(:radio, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_radio_button_tag(@name, @value, :label => '')
        assert_equal expected, result
      end
      should "render standalone radio button with nested name" do
        @name = "user[level]"
        @opts[:id] = "user_level"
        expected = input_tag(:radio, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_radio_button_tag(@name, @value, :label => '')
        assert_equal expected, result
      end
      should "render standalone radio button checked" do
        @opts[:checked] = Useful::ErbHelpers::Common::OPTIONS[:checked]
        expected = input_tag(:radio, @name, @value, @opts)
        erb_helper_clear_output_buffer
        result = proper_radio_button_tag(@name, @value, true, :label => '')
        assert_equal expected, result
      end
      should "render labeled radio button" do
        label_text = '1'
        rdbtn = input_tag(:radio, @name, @value, @opts)
        expected = tag(:label, :for => @opts[:id]) do
          rdbtn + tag(:span) { label_text }
        end
        erb_helper_clear_output_buffer
        result = proper_radio_button_tag(@name, @value)
        assert_equal expected, result
      end
    end

  end

end