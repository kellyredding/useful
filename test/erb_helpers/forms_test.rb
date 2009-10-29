require File.dirname(__FILE__) + '/../test_helper'

class FormsTest < Test::Unit::TestCase
  
  include Useful::ErbHelpers::Forms

  context "the erb helper" do
    
    context "'form_tag'" do
      setup do
        @url = "/foo"
        @form_opts = { :action => @url }
      end

      should "render with the default method to the url specified" do
        @form_opts[:method] = 'post'
        assert_equal tag(:form, @form_opts), form_tag(@url)
      end
      should "render with the default method if an invalid method is specified" do
        @form_opts[:method] = 'post'
        assert_equal tag(:form, @form_opts), form_tag(@url, :method => 'update')
      end
      should "render for multipart with a custom method" do
        @form_opts[:method] = 'put'
        @form_opts[:enctype] = 'multipart/form-data'
        assert_equal tag(:form, @form_opts), form_tag(@url, :method => 'put', :multipart => true)
      end
      should "render with a block passed" do
        @form_opts[:method] = 'post'
        content = "some content here"
        assert_equal tag(:form, @form_opts) { content }, form_tag(@url) { content }
      end
    end

    context "'field_set_tag'" do
      should "render with no legend" do
        assert_equal tag(:fieldset) { '' }, field_set_tag
      end
      should "render with a legend" do
        legend_text = "Good Times"
        assert_equal tag(:fieldset) { tag(:legend) { legend_text.to_s } }, field_set_tag(legend_text)
      end
      should "render with a block passed" do
        content = "some content here"
        assert_equal tag(:fieldset) { content }, field_set_tag { content }
      end
    end
    
    context "'label_tag'" do
      should "render with value implied from the name" do
        name = "user"
        assert_equal tag(:label, :for => name) { "User" }, label_tag(name)
      end
      should "render with value implied from an ugly name" do
        name = "user[name]"
        assert_equal tag(:label, :for => erb_helper_common_safe_id(name)) { "User name" }, label_tag(name)
      end
      should "render with explicit value and for an explicit id" do
        name = "user"
        id = "current_user"
        assert_equal tag(:label, :for => id) { "Current User" }, label_tag(name, "Current User", :for => id)
      end
    end
    
    context "'hidden_field_tag'" do
      setup do
        @name = 'user'
        @value = 'bob'
      end
      should "render with just a name" do
        assert_equal input_tag('hidden', @name), hidden_field_tag(@name)
      end
      should "render with just a name and value" do
        assert_equal input_tag('hidden', @name, @value), hidden_field_tag(@name, @value)
      end
      should "render with a name and value and options" do
        opts = { :class => 'awesome' }
        assert_equal input_tag('hidden', @name, @value, opts), hidden_field_tag(@name, @value, opts)
      end
    end
    
    context "'text_field_tag'" do
      setup do
        @name = 'user'
        @value = 'bob'
      end
      should "render with just a name" do
        assert_equal input_tag('text', @name), text_field_tag(@name)
      end
      should "render with just a name and value" do
        assert_equal input_tag('text', @name, @value), text_field_tag(@name, @value)
      end
      should "render with a name and value and options" do
        opts = { :class => 'awesome' }
        assert_equal input_tag('text', @name, @value, opts), text_field_tag(@name, @value, opts)
      end
    end
    
    context "'password_field_tag'" do
      setup do
        @name = 'user'
        @value = 'bob'
      end
      should "render with no args" do
        assert_equal input_tag('password', 'password'), password_field_tag
      end
      should "render with just a name" do
        assert_equal input_tag('password', @name), password_field_tag(@name)
      end
      should "render with just a name and value" do
        assert_equal input_tag('password', @name, @value), password_field_tag(@name, @value)
      end
      should "render with a name and value and options" do
        opts = { :size => 15 }
        assert_equal input_tag('password', @name, @value, opts), password_field_tag(@name, @value, opts)
      end
    end
    
    context "'file_field_tag'" do
      setup do
        @name = 'resume'
      end
      should "render with just a name" do
        assert_equal input_tag('file', @name), file_field_tag(@name)
      end
      should "render with a name and options" do
        opts = { :class => 'awesome' }
        assert_equal input_tag('file', @name, nil, opts), file_field_tag(@name, opts)
      end
    end
    
    context "'submit_tag'" do
      should "render with no args" do
        assert_equal input_tag('submit', 'commit', Useful::ErbHelpers::Common::OPTIONS[:default_submit_value]), submit_tag
      end
      should "render with just a value" do
        val = "Edit this article"
        assert_equal input_tag('submit', 'commit', val), submit_tag(val)
      end
      should "render disabled with" do
        val = "Edit"
        dis_with = "Saving..."
        assert_equal input_tag('submit', 'commit', val, :onclick => erb_helper_disable_with_javascript(dis_with)), submit_tag(val, :disabled_with => dis_with)
      end
      should "render confirmed" do
        val = "Edit"
        confirm = "Sure?"
        assert_equal input_tag('submit', 'commit', val, :onclick => "if (!#{erb_helper_confirm_javascript(confirm)}) return false; return true;"), submit_tag(val, :confirm => confirm)
      end
    end
    
    context "'image_submit_tag'" do
      setup do
        @opts = {:class => 'awesome', :alt => Useful::ErbHelpers::Common::OPTIONS[:default_submit_value]}
        @img_name = "charles.jpg"
        @img_def_src = "/images/#{@img_name}"
        @img_cust_src = "/in_charge/#{@img_name}"
      end
      should "render without an image path" do
        opts = {:src => @img_def_src, :alt => Useful::ErbHelpers::Common::OPTIONS[:default_submit_value]}
        assert_equal input_tag('image', nil, nil, opts), image_submit_tag(@img_name)
      end
      should "render with an image path" do
        assert_equal input_tag('image', nil, nil, @opts.merge(:src => @img_cust_src)), image_submit_tag(@img_cust_src, @opts)
      end
      should "render confirmed" do
        confirm = "Sure?"
        opts = {:src => @img_def_src, :onclick => "if (!#{erb_helper_confirm_javascript(confirm)}) return false; return true;", :alt => Useful::ErbHelpers::Common::OPTIONS[:default_submit_value]}
        assert_equal input_tag('image', nil, nil, opts), image_submit_tag(@img_name, :confirm => confirm)
      end
    end
    
    context "'text_area_tag'" do
      setup do
        @name = 'user'
        @content = 'bob'
        @opts = { :tag => 'textarea' }
      end
      should "render with just a name" do
        @content = nil
        expected = input_tag(nil, @name, nil, @opts) { '' }
        erb_helper_clear_output_buffer
        result = text_area_tag(@name)
        assert_equal expected, result
      end
      should "render with a name and content escaped by default" do
        @content = "<h1>Awesome</h1>"
        expected = input_tag(nil, @name, nil, @opts) { escape_html(@content) }
        erb_helper_clear_output_buffer
        result = text_area_tag(@name, @content)
        assert_equal expected, result
      end
      should "render content unescaped" do
        @content = "<h1>Awesome</h1>"
        expected = input_tag(nil, @name, nil, @opts) { @content }
        erb_helper_clear_output_buffer
        result = text_area_tag(@name, @content, :escape => false)
        assert_equal expected, result
      end
      context "with size options" do
        setup do
          @size = "25x10"
          @rows = 5
          @cols = 8
        end
        should "render with size" do
          @content = nil
          sizes = @size.split('x')
          expected = input_tag(nil, @name, nil, @opts.merge(:cols => sizes.first, :rows => sizes.last)) { '' }
          erb_helper_clear_output_buffer
          result = text_area_tag(@name, nil, :size => @size)
          assert_equal expected, result
        end
        should "render with row/col options" do
          @content = nil
          expected = input_tag(nil, @name, nil, @opts.merge(:cols => @cols, :rows => @rows)) { '' }
          erb_helper_clear_output_buffer
          result = text_area_tag(@name, nil, :cols => @cols, :rows => @rows)
          assert_equal expected, result
        end
        should "render with size and row/col options, preferring the size option" do
          @content = nil
          sizes = @size.split('x')
          expected = input_tag(nil, @name, nil, @opts.merge(:cols => sizes.first, :rows => sizes.last)) { '' }
          erb_helper_clear_output_buffer
          result = text_area_tag(@name, nil, :size => @size, :cols => @cols, :rows => @rows)
          assert_equal expected, result
        end
      end
    end

  end

end