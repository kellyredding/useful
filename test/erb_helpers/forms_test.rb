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
    
    context "'input_tag'" do
      setup do
        @opts = {
          :type => 'text',
          :name => 'user',
          :id => 'user'
        }
      end
      should "render with type, name, and default tag" do
        assert_equal tag(:input, @opts), input_tag(@opts[:type], @opts[:name])
      end
      should "render with custom tag" do
        @opts.delete(:type)
        tag = 'textarea'
        assert_equal tag(tag, @opts), input_tag(nil, @opts[:name], nil, :tag => tag)
      end
      should "render with value implied from an ugly name" do
        @opts[:name] = 'user[name]'
        @opts[:id] = 'user_name'
        assert_equal tag(:input, @opts), input_tag(@opts[:type], @opts[:name])
      end
      should "render with explicit value" do
        @opts[:value] = "some awesome text"
        assert_equal tag(:input, @opts), input_tag(@opts[:type], @opts[:name], @opts[:value])
      end
      should "render with a block passed" do
        content = "some content here"
        assert_equal tag(:input, @opts) { content }, input_tag(@opts[:type], @opts[:name]) { content }
      end
      should "render disabled" do
        @opts[:disabled] = Useful::ErbHelpers::Common::OPTIONS[:disabled]
        assert_equal tag(:input, @opts), input_tag(@opts[:type], @opts[:name], @opts[:value], :disabled => true)
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
    
  end

end