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
        assert_equal tag(:form, @form_opts) { "some form content here"}, form_tag(@url) { "some form content here"}
      end
    end

  end

end