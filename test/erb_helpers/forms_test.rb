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
    end
    
  end

end